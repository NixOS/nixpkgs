{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  docutils,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "bcdoc";
  version = "0.16.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-9WjBguBog77PcZbyJwUkNc/9RWBHAMgjYsp300J7YgI=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    docutils
    six
  ];

  # Tests fail due to nix file timestamp normalization.
  doCheck = false;

  pythonImportsCheck = [ "bcdoc" ];

  meta = {
    homepage = "https://github.com/boto/bcdoc";
    license = lib.licenses.asl20;
    description = "ReST document generation tools for botocore";
  };
})
