{
  lib,
  buildPythonPackage,
  fetchPypi,
  docutils,
  six,
}:

buildPythonPackage rec {
  pname = "bcdoc";
  version = "0.16.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9WjBguBog77PcZbyJwUkNc/9RWBHAMgjYsp300J7YgI=";
  };

  buildInputs = [
    docutils
    six
  ];

  # Tests fail due to nix file timestamp normalization.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/boto/bcdoc";
    license = licenses.asl20;
    description = "ReST document generation tools for botocore";
  };
}
