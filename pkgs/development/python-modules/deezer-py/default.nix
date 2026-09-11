{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "deezer-py";
  version = "1.3.7";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-saMy+IeAy6H9SgS8XHnZ9klFerGyr+vQqhuCtimgbEo=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "requests" ];

  meta = {
    homepage = "https://gitlab.com/RemixDev/deezer-py";
    description = "Wrapper for all Deezer's APIs";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ natto1784 ];
  };
})
