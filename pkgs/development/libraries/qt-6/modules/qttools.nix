{ qtModule
, stdenv
, lib
, qtbase
, qtdeclarative
, substituteAll
}:

qtModule {
  pname = "qttools";
  qtInputs = [ qtbase qtdeclarative ];
  patches = [
    ../patches/qttools-paths.patch
  ];
  NIX_CFLAGS_COMPILE = [
    "-DNIX_OUTPUT_DEV=\"${placeholder "dev"}\""
  ];
}
