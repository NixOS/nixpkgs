{ stdenv, buildPythonPackage, fetchPypi
, betamax, requests_toolbelt }:

buildPythonPackage rec {
  pname = "betamax-matchers";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07qpwjyq2i2aqhz5iwghnj4pqr2ys5n45v1vmpcfx9r5mhwrsq43";
  };

  buildInputs = [ betamax requests_toolbelt ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sigmavirus24/betamax_matchers";
    description = "A group of experimental matchers for Betamax";
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
  };
}
