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
  env.NIX_CFLAGS_COMPILE = toString [
    "-DNIX_OUTPUT_OUT=\"${placeholder "out"}\""
  ];
  postInstall = ''
    mkdir -p "$dev"
    ln -s "$out/bin" "$dev/bin"
  '';
}
