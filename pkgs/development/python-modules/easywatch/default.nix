{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  watchdog,
}:

buildPythonPackage (finalAttrs: {
  pname = "easywatch";
  version = "0.0.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-DN7XAQYIPq3m4y9m7vH5QAywOfTG9w6RxEmf/aJkgKw=";
  };

  build-system = [ setuptools ];

  dependencies = [ watchdog ];

  # There are no tests
  doCheck = false;
  pythonImportsCheck = [ "easywatch" ];

  meta = {
    description = "Dead-simple way to watch a directory";
    homepage = "https://github.com/Ceasar/easywatch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
  };
})
