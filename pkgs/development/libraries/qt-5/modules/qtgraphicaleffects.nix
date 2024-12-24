{ qtModule, qtdeclarative }:

qtModule {
  pname = "qtgraphicaleffects";
  propagatedBuildInputs = [ qtdeclarative ];
  outputs = [
    "out"
    "dev"
  ];
}
