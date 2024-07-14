{
  lib,
  buildPythonPackage,
  fetchPypi,
  betamax,
  requests-toolbelt,
}:

buildPythonPackage rec {
  pname = "betamax-matchers";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g2CdOawlp+7YrTvsQmzRXmR8ibTw8Vg+xEpEgb3kFx8=";
  };

  buildInputs = [
    betamax
    requests-toolbelt
  ];

  meta = with lib; {
    homepage = "https://github.com/sigmavirus24/betamax_matchers";
    description = "Group of experimental matchers for Betamax";
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
  };
}
