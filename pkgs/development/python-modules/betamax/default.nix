{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "betamax";
  version = "0.8.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hki1c2vs7adq7zr56wi6i5bhrkia4s2ywpv2c98ibnczz709w2v";
  };

  propagatedBuildInputs = [ requests ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://betamax.readthedocs.org/en/latest/";
    description = "A VCR imitation for requests";
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
  };
}
