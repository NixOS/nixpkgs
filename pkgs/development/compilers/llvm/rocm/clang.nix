{ stdenv
, lib
, fetchFromGitHub
, cmake
, python3
, llvm
, clang-tools-extra_src ? null
, lld

, version
, src
}:

stdenv.mkDerivation rec {
  inherit version src;

  pname = "clang";

  nativeBuildInputs = [ cmake python3 ];

  buildInputs = [ llvm ];

  hardeningDisable = [ "all" ];

  cmakeFlags = [
    "-DLLVM_CMAKE_PATH=${llvm}/lib/cmake/llvm"
    "-DLLVM_MAIN_SRC_DIR=${llvm.src}"
    "-DCLANG_SOURCE_DIR=${src}"
    "-DLLVM_ENABLE_RTTI=ON"
  ];

  VCSVersion = ''
    #undef LLVM_REVISION
    #undef LLVM_REPOSITORY
    #undef CLANG_REVISION
    #undef CLANG_REPOSITORY
  '';

  postUnpack = lib.optionalString (!(isNull clang-tools-extra_src)) ''
    ln -s ${clang-tools-extra_src} $sourceRoot/tools/extra
  '';

  # Rather than let cmake extract version information from LLVM or
  # clang source control repositories, we generate the wanted
  # `VCSVersion.inc` file ourselves and remove it from the
  # depencencies of the `clangBasic` target.
  preConfigure = ''
    sed 's/  ''${version_inc}//' -i lib/Basic/CMakeLists.txt
    sed 's|sys::path::parent_path(BundlerExecutable)|StringRef("${llvm}/bin")|' -i tools/clang-offload-bundler/ClangOffloadBundler.cpp
    sed 's|\([[:space:]]*std::string Linker = \)getToolChain().GetProgramPath(getShortName())|\1"${lld}/bin/ld.lld"|' -i lib/Driver/ToolChains/AMDGPU.cpp
    substituteInPlace lib/Driver/ToolChains/AMDGPU.h --replace ld.lld ${lld}/bin/ld.lld
    sed 's|configure_file(AST/gen_ast_dump_json_test.py ''${LLVM_TOOLS_BINARY_DIR}/gen_ast_dump_json_test.py COPYONLY)||' -i test/CMakeLists.txt
  '';

  postConfigure = ''
    mkdir -p lib/Basic
    echo "$VCSVersion" > lib/Basic/VCSVersion.inc
  '';

  passthru = {
    isClang = true;
    inherit llvm;
  };

  meta = with lib; {
    description = "ROCm fork of the clang C/C++/Objective-C/Objective-C++ LLVM compiler frontend";
    homepage = "https://llvm.org/";
    license = with licenses; [ ncsa ];
    maintainers = with maintainers; [ acowley lovesegfault ];
    platforms = platforms.linux;
  };
}
