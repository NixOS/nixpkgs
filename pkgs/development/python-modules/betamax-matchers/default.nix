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
    sha256 = "07qpwjyq2i2aqhz5iwghnj4pqr2ys5n45v1vmpcfx9r5mhwrsq43";
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
