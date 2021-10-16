{ qtModule
, qtbase
, qtdeclarative
, qtsvg
, hunspell
, pkg-config
}:

qtModule {
  pname = "qtvirtualkeyboard";
  qtInputs = [ qtbase qtdeclarative qtsvg ];
  propagatedBuildInputs = [ hunspell ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [ "out" ];
}
