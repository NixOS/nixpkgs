{ cmake
, fetchFromGitHub
, fetchgit
, git
, lib
, libffi
, llvmPackages_9
, makeWrapper
, ncurses
, python3
, runCommand
, zlib

# *NOT* from LLVM 9!
# The compiler used to compile Cling may affect the runtime include and lib
# directories it expects to be run with. Cling builds against (a fork of) Clang,
# so we prefer to use Clang as the compiler as well for consistency.
# It would be cleanest to use LLVM 9's clang, but it errors. So, we use a later
# version of Clang to compile, but we check out the Cling fork of Clang 9 to
# build Cling against.
, clangStdenv

# For runtime C++ standard library
, gcc-unwrapped

# Build with debug symbols
, debug ? false

# Build with libc++ (LLVM) rather than stdlibc++ (GCC).
# This is experimental and not all features work.
, useLLVMLibcxx ? false
}:

let
  stdenv = clangStdenv;

  # The LLVM 9 headers have a couple bugs we need to patch
  fixedLlvmDev = runCommand "llvm-dev-${llvmPackages_9.llvm.version}" { buildInputs = [git]; } ''
    mkdir $out
    cp -r ${llvmPackages_9.llvm.dev}/include $out
    cd $out
    chmod -R u+w include
    git apply ${./fix-llvm-include.patch}
  '';

  unwrapped = stdenv.mkDerivation rec {
    pname = "cling-unwrapped";
    version = "0.9";

    src = fetchgit {
      url = "http://root.cern/git/clang.git";
      rev = "cling-v0.9";
      sha256 = "sha256-ft1NUIclSiZ9lN3Z3DJCWA0U9q/K1M0TKkZr+PjsFYk=";
    };

    clingSrc = fetchFromGitHub {
      owner = "root-project";
      repo = "cling";
      rev = "v0.9";
      sha256 = "0wx3fi19wfjcph5kclf8108i436y79ddwakrcf0lgxnnxhdjyd29";
    };

    prePatch = ''
      echo "add_llvm_external_project(cling)" >> tools/CMakeLists.txt

      cp -r $clingSrc ./tools/cling
      chmod -R a+w ./tools/cling
    '';

    patches = [
      ./no-clang-cpp.patch

      # https://github.com/root-project/root/commit/286d96b12aad8688b9d8e4b3b5df843dcfb716a8
      ./fix-llvm-dylib-usage.patch

      ./force-install-cling-targets.patch
    ];

    nativeBuildInputs = [ python3 git cmake ];
    buildInputs = [ libffi ncurses zlib ];

    strictDeps = true;

    cmakeFlags = [
      "-DLLVM_BINARY_DIR=${llvmPackages_9.llvm.out}"
      "-DLLVM_CONFIG=${llvmPackages_9.llvm.dev}/bin/llvm-config"
      "-DLLVM_LIBRARY_DIR=${llvmPackages_9.llvm.lib}/lib"
      "-DLLVM_MAIN_INCLUDE_DIR=${fixedLlvmDev}/include"
      "-DLLVM_TABLEGEN_EXE=${llvmPackages_9.llvm.out}/bin/llvm-tblgen"
      "-DLLVM_TOOLS_BINARY_DIR=${llvmPackages_9.llvm.out}/bin"
      "-DLLVM_BUILD_TOOLS=Off"
      "-DLLVM_TOOL_CLING_BUILD=ON"

      "-DLLVM_TARGETS_TO_BUILD=host;NVPTX"
      "-DLLVM_ENABLE_RTTI=ON"

      # Setting -DCLING_INCLUDE_TESTS=ON causes the cling/tools targets to be built;
      # see cling/tools/CMakeLists.txt
      "-DCLING_INCLUDE_TESTS=ON"
      "-DCLANG-TOOLS=OFF"
    ] ++ lib.optionals debug [
      "-DCMAKE_BUILD_TYPE=Debug"
    ] ++ lib.optionals useLLVMLibcxx [
      "-DLLVM_ENABLE_LIBCXX=ON"
      "-DLLVM_ENABLE_LIBCXXABI=ON"
    ];

    CPPFLAGS = if useLLVMLibcxx then [ "-stdlib=libc++" ] else [];

    postInstall = lib.optionalString (!stdenv.isDarwin) ''
      mkdir -p $out/share/Jupyter
      cp -r /build/clang/tools/cling/tools/Jupyter/kernel $out/share/Jupyter
    '';

    dontStrip = debug;

    meta = with lib; {
      description = "The Interactive C++ Interpreter";
      homepage = "https://root.cern/cling/";
      license = with licenses; [ lgpl21 ncsa ];
      maintainers = with maintainers; [ thomasjm ];
      platforms = platforms.unix;
    };
  };

  # Runtime flags for the C++ standard library
  cxxFlags = if useLLVMLibcxx then [
    "-I" "${lib.getDev llvmPackages_9.libcxx}/include/c++/v1"
    "-L" "${llvmPackages_9.libcxx}/lib"
    "-l" "${llvmPackages_9.libcxx}/lib/libc++.so"
  ] else [
    "-I" "${gcc-unwrapped}/include/c++/${gcc-unwrapped.version}"
    "-I" "${gcc-unwrapped}/include/c++/${gcc-unwrapped.version}/x86_64-unknown-linux-gnu"
  ];

  # The flags passed to the wrapped cling should
  # a) prevent it from searching for system include files and libs, and
  # b) provide it with the include files and libs it needs (C and C++ standard library plus
  # its own stuff)

  # These are also exposed as cling.flags because it's handy to be able to pass them to tools
  # that wrap Cling, particularly Jupyter kernels such as xeus-cling and the built-in
  # jupyter-cling-kernel, which use Cling as a library.
  # Thus, if you're packaging a Jupyter kernel, you either need to pass these flags as extra
  # args to xcpp (for xeus-cling) or put them in the environment variable CLING_OPTS
  # (for jupyter-cling-kernel).
  flags = [
    "-nostdinc"
    "-nostdinc++"

    "-isystem" "${lib.getLib unwrapped}/lib/clang/9.0.1/include"
  ]
  ++ cxxFlags
  ++ [
    # System libc
    "-isystem" "${lib.getDev stdenv.cc.libc}/include"

    # cling includes
    "-isystem" "${lib.getDev unwrapped}/include"
  ];

in

runCommand "cling-${unwrapped.version}" {
  nativeBuildInputs = [ makeWrapper ];
  inherit unwrapped flags;
  inherit (unwrapped) meta;
} ''
  makeWrapper $unwrapped/bin/cling $out/bin/cling \
    --add-flags "$flags"
''
