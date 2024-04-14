{ qtModule, qtbase, qtdeclarative, qtsvg, hunspell  }:

qtModule {
  pname = "qtvirtualkeyboard";
  propagatedBuildInputs = [ qtbase qtdeclarative qtsvg hunspell ];
}
