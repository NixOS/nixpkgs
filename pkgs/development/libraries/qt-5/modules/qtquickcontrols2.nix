{ qtModule, qtdeclarative }:

qtModule {
  pname = "qtquickcontrols2";
  propagatedBuildInputs = [ qtdeclarative ];
  outputs = [ "out" "dev" "bin" ];
}
