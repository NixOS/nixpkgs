{ stdenv, qtModule, qtbase, qtmultimedia }:

qtModule {
  name = "qtlocation";
  qtInputs = [ qtbase qtmultimedia ];
  outputs = [ "bin" "out" "dev" ];
  qmakeFlags = stdenv.lib.optional stdenv.isDarwin [
     # boost uses std::auto_ptr which has been disabled in clang with libcxx
     # This flag re-enables this feature
     # https://libcxx.llvm.org/docs/UsingLibcxx.html#c-17-specific-configuration-macros
     "QMAKE_CXXFLAGS+=-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR"
  ];

}
