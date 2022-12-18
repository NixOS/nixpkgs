{ stdenv
, lib
, fetchgit
, fetchFromGitHub
, writeScript
, cmake
, ninja
, python3
, libxml2
, libffi
, libbfd
, libxcrypt
, ncurses
, zlib
, debugVersion ? false
, enableManpages ? false

, version
, src
}:

let
  llvmNativeTarget =
    if stdenv.isx86_64 then "X86"
    else if stdenv.isAarch64 then "AArch64"
    else throw "Unsupported ROCm LLVM platform";
in stdenv.mkDerivation (finalAttrs: {
  inherit src version;

  pname = "rocm-llvm";

  sourceRoot = "${src.name}/llvm";

  nativeBuildInputs = [ cmake ninja python3 ];

  buildInputs = [ libxml2 libxcrypt ];

  propagatedBuildInputs = [ ncurses zlib ];

  cmakeFlags = with stdenv; [
    "-DCMAKE_BUILD_TYPE=${if debugVersion then "Debug" else "Release"}"
    "-DLLVM_INSTALL_UTILS=ON" # Needed by rustc
    "-DLLVM_TARGETS_TO_BUILD=AMDGPU;${llvmNativeTarget}"
    "-DLLVM_ENABLE_PROJECTS=clang;lld;compiler-rt"
  ]
  ++ lib.optionals enableManpages [
    "-DLLVM_BINUTILS_INCDIR=${libbfd.dev}/include"
    "-DLLVM_BUILD_DOCS=ON"
    "-DLLVM_ENABLE_SPHINX=ON"
    "-DSPHINX_OUTPUT_MAN=ON"
    "-DSPHINX_OUTPUT_HTML=OFF"
    "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
  ];

  postPatch = ''
    patchShebangs lib/OffloadArch/make_generated_offload_arch_h.sh
    substituteInPlace ../clang/cmake/modules/CMakeLists.txt \
      --replace 'FILES_MATCHING' 'NO_SOURCE_PERMISSIONS FILES_MATCHING'
  '';

  passthru = {
    isClang = true;

    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq common-updater-scripts nix-prefetch-github

      version="$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
        -sL "https://api.github.com/repos/RadeonOpenCompute/llvm-project/releases?per_page=1" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"

      IFS='.' read -a version_arr <<< "$version"

      if [ "''${#version_arr[*]}" == 2 ]; then
        version="''${version}.0"
      fi

      current_version="$(grep "version =" pkgs/development/compilers/llvm/rocm/default.nix | cut -d'"' -f2)"
      if [[ "$version" != "$current_version" ]]; then
        tarball_meta="$(nix-prefetch-github RadeonOpenCompute llvm-project --rev "rocm-$version")"
        tarball_hash="$(nix to-base64 sha256-$(jq -r '.sha256' <<< "$tarball_meta"))"
        sed -i "pkgs/development/compilers/llvm/rocm/default.nix" \
          -e 's,version = "\(.*\)",version = "'"$version"'",' \
          -e 's,hash = "\(.*\)",hash = "sha256-'"$tarball_hash"'",'
      else
        echo rocm-llvm already up-to-date
      fi
    '';
    };

  meta = with lib; {
    description = "ROCm fork of the LLVM compiler infrastructure";
    homepage = "https://github.com/RadeonOpenCompute/llvm-project";
    license = with licenses; [ ncsa ];
    maintainers = with maintainers; [ acowley lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
  };
})
