{
  lib,
  stdenv,
  qtModule,
  qtbase,
  qtmultimedia,
}:

qtModule {
  pname = "qtlocation";
  propagatedBuildInputs = [
    qtbase
    qtmultimedia
  ];
  outputs = [
    "bin"
    "out"
    "dev"
  ];
  # Clang 18 treats a non-const, narrowing conversion in an initializer list as an error,
  # which results in a failure building a 3rd party dependency of qtlocation. Just suppress it.
  env =
    lib.optionalAttrs (stdenv.cc.isClang && (lib.versionAtLeast (lib.getVersion stdenv.cc) "18"))
      {
        NIX_CFLAGS_COMPILE = "-Wno-c++11-narrowing-const-reference";
      };
  qmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # boost uses std::auto_ptr which has been disabled in clang with libcxx
    # This flag re-enables this feature
    # https://libcxx.llvm.org/docs/UsingLibcxx.html#c-17-specific-configuration-macros
    "QMAKE_CXXFLAGS+=-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR"
    "QMAKE_CXXFLAGS+=-D_LIBCPP_ENABLE_CXX17_REMOVED_UNARY_BINARY_FUNCTION"
  ];
}
