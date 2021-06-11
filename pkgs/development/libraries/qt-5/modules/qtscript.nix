{ qtModule, qtbase, qttools }:

qtModule {
  pname = "qtscript";
  qtInputs = [ qtbase qttools ];
}
