{ lib, stdenv, fetchFromGitHub, writeScript, cmake, clang, rocm-device-libs, llvm }:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-comgr";
  version = "5.3.3";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-CompilerSupport";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-LQyMhqcWm8zqt6138fnT7EOq/F8bG3Iuf04PTemVQmg=";
  };

  sourceRoot = "source/lib/comgr";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ clang rocm-device-libs llvm ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=${clang}/bin/clang"
    "-DCMAKE_CXX_COMPILER=${clang}/bin/clang++"
    "-DCMAKE_PREFIX_PATH=${llvm}/lib/cmake/llvm"
    "-DLLD_INCLUDE_DIRS=${llvm}/include"
    "-DLLVM_TARGETS_TO_BUILD=\"AMDGPU;X86\""
  ];

  patches = [ ./cmake.patch ];

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl ''${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} -sL "https://api.github.com/repos/RadeonOpenCompute/ROCm-CompilerSupport/releases?per_page=1" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    update-source-version rocm-comgr "$version" --ignore-same-hash
  '';

  meta = with lib; {
    description = "APIs for compiling and inspecting AMDGPU code objects";
    homepage = "https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/tree/amd-stg-open/lib/comgr";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
  };
})
