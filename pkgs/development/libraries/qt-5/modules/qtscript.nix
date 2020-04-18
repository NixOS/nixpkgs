{ qtModule, qtbase, qttools }:

qtModule {
  name = "qtscript";
  qtInputs = [ qtbase qttools ];
}
