{
  lib,
  buildPythonPackage,
  fetchPypi,

  setuptools,

  six,
  requests,
  beautifulsoup4,
}:

buildPythonPackage (finalAttrs: {
  pname = "feedfinder2";
  version = "0.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-NwHuAabIX4uGWgScMLoLRgiFjIA/6OMNHSif2+idDv4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    requests
    beautifulsoup4
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "feedfinder2" ];

  meta = {
    description = "Python library for finding feed links on websites";
    homepage = "https://github.com/dfm/feedfinder2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vizid ];
  };
})
