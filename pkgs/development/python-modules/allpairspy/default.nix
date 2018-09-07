{ lib, buildPythonPackage, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "allpairspy";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e8b35751f91692bf0318091b3f44cdf9bbbe3f37a2ff4786eaffc09dc7114fb3";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Pairwise test combinations generator";
    homepage = https://github.com/thombashi/allpairspy;
    license = licenses.mit;
  };
}
