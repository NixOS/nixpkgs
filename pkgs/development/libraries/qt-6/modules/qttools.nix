{ qtModule
, stdenv
, lib
, qtbase
, qtdeclarative
, cups
, substituteAll
}:

qtModule {
  pname = "qttools";
  qtInputs = [ qtbase qtdeclarative ];
  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ cups ];
  patches = [
    ../patches/qttools-paths.patch
  ];
  NIX_CFLAGS_COMPILE = [
    "-DNIX_OUTPUT_DEV=\"${placeholder "dev"}\""
  ];
}
