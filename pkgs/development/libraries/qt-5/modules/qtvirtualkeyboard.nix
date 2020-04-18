{ qtModule, qtbase, qtdeclarative, qtsvg, hunspell  }:

qtModule {
  name = "qtvirtualkeyboard";
  qtInputs = [ qtbase qtdeclarative qtsvg hunspell ];
}
