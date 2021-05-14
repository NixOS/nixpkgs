{ qtModule, qtdeclarative }:

qtModule {
  pname = "qtgraphicaleffects";
  qtInputs = [ qtdeclarative ];
  outputs = [ "out" "dev" ];
}
