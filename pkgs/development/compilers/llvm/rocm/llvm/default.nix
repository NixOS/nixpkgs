{ stdenv
, lib
, fetchFromGitHub
, writeScript
, cmake
, python3
, libxml2
, libffi
, libbfd
, ncurses
, zlib
, debugVersion ? false
, enableManpages ? false
, enableSharedLibraries ? !stdenv.hostPlatform.isStatic

, version
, src
}:

let
  llvmNativeTarget =
    if stdenv.isx86_64 then "X86"
    else if stdenv.isAarch64 then "AArch64"
    else throw "Unsupported ROCm LLVM platform";
in stdenv.mkDerivation rec {
  inherit src version;

  pname = "rocm-llvm";

  outputs = [ "out" "python" ]
    ++ lib.optional enableSharedLibraries "lib";

  nativeBuildInputs = [ cmake python3 ];

  buildInputs = [ libxml2 libffi ];

  propagatedBuildInputs = [ ncurses zlib ];

  cmakeFlags = with stdenv; [
    "-DCMAKE_BUILD_TYPE=${if debugVersion then "Debug" else "Release"}"
    "-DLLVM_INSTALL_UTILS=ON" # Needed by rustc
    "-DLLVM_BUILD_TESTS=OFF"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_ENABLE_RTTI=ON"
    "-DLLVM_ENABLE_DUMP=ON"
    "-DLLVM_TARGETS_TO_BUILD=AMDGPU;${llvmNativeTarget}"
  ]
  ++
  lib.optional
    enableSharedLibraries
    "-DLLVM_LINK_LLVM_DYLIB=ON"
  ++ lib.optionals enableManpages [
    "-DLLVM_BINUTILS_INCDIR=${libbfd.dev}/include"
    "-DLLVM_BUILD_DOCS=ON"
    "-DLLVM_ENABLE_SPHINX=ON"
    "-DSPHINX_OUTPUT_MAN=ON"
    "-DSPHINX_OUTPUT_HTML=OFF"
    "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
  ];

  postPatch = ''
    substitute '${./outputs.patch}' ./outputs.patch --subst-var lib
    patch -p1 < ./outputs.patch
  '';

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';

  postBuild = ''
    rm -fR $out
  '';

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD/lib
  '';

  postInstall = ''
    moveToOutput share/opt-viewer "$python"
  ''
  + lib.optionalString enableSharedLibraries ''
    moveToOutput "lib/libLLVM-*" "$lib"
    moveToOutput "lib/libLLVM${stdenv.hostPlatform.extensions.sharedLibrary}" "$lib"
    substituteInPlace "$out/lib/cmake/llvm/LLVMExports-${if debugVersion then "debug" else "release"}.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/libLLVM-" "$lib/lib/libLLVM-"
  '';

  passthru.src = src;

  updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts nix-prefetch-github

    version="$(curl -sL "https://api.github.com/repos/RadeonOpenCompute/llvm-project/releases?per_page=1" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
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

  meta = with lib; {
    description = "ROCm fork of the LLVM compiler infrastructure";
    homepage = "https://github.com/RadeonOpenCompute/llvm-project";
    license = with licenses; [ ncsa ];
    maintainers = with maintainers; [ acowley lovesegfault ];
    platforms = platforms.linux;
  };
}
