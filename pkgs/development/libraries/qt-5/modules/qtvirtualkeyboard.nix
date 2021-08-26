{ qtModule, qtbase, qtdeclarative, qtsvg, hunspell  }:

qtModule {
  pname = "qtvirtualkeyboard";
  qtInputs = [ qtbase qtdeclarative qtsvg hunspell ];
}
