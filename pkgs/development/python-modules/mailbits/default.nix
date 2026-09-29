{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  attrs,
}:

buildPythonPackage (finalAttrs: {
  pname = "mailbits";
  version = "0.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ExQL6Ugl1ECYbe4KbmU9gdO030sAWfvbbXi6jMsMTsA=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    attrs
  ];

  pythonImportsCheck = [
    "mailbits"
  ];

  meta = {
    description = "Assorted e-mail utility functions";
    homepage = "https://pypi.org/project/mailbits";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booxter ];
  };
})
