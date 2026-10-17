{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  pynacl,
}:

buildPythonPackage rec {
  pname = "pymacaroons";
  version = "0.13.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hmu6QqX2bCRa3zilpABqmdzAagcDeG6mNgmGZ9QpA7g=";
  };

  propagatedBuildInputs = [
    six
    pynacl
  ];

  # Tests require an old version of hypothesis
  doCheck = false;

  meta = {
    description = "Macaroon library for Python";
    homepage = "https://github.com/ecordell/pymacaroons";
    license = lib.licenses.mit;
  };
}
