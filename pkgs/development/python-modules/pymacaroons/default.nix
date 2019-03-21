{ lib, buildPythonPackage, fetchPypi, six, pynacl }:

buildPythonPackage rec {
  pname = "pymacaroons";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8";
  };

  propagatedBuildInputs = [
    six
    pynacl
  ];

  # Tests require an old version of hypothesis
  doCheck = false;

  meta = with lib; {
    description = "Macaroon library for Python";
    homepage = https://github.com/ecordell/pymacaroons;
    license = licenses.mit;
  };
}
