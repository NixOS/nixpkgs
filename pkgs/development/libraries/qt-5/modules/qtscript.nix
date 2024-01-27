{ qtModule, qtbase, qttools }:

qtModule {
  pname = "qtscript";
  propagatedBuildInputs = [ qtbase qttools ];
}
