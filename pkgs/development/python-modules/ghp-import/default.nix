{
  lib,
  buildPythonPackage,
  fetchPypi,
  python-dateutil,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ghp-import";
  version = "2.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-nFNcTGEZPC34hxIiVn1/1+UBTYNfl9x7dDkGniQT00M=";
  };

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  # Does not include any unit tests
  doCheck = false;

  pythonImportsCheck = [ "ghp_import" ];

  meta = {
    description = "Copy your docs directly to the gh-pages branch";
    mainProgram = "ghp-import";
    homepage = "https://github.com/c-w/ghp-import";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veehaitch ];
  };
})
