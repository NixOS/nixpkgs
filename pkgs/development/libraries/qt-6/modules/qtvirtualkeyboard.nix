{ qtModule
, qtbase
, qtdeclarative
, qtsvg
, hunspell
, pkg-config
}:

qtModule {
  pname = "qtvirtualkeyboard";
  propagatedBuildInputs = [ qtbase qtdeclarative qtsvg hunspell ];
  nativeBuildInputs = [ pkg-config ];
}
