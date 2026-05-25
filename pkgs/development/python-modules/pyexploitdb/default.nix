{
  lib,
  buildPythonPackage,
  fetchPypi,
  gitpython,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyexploitdb";
  version = "0.3.27";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-B4xd+wXaZC3gl+uyGlM+y3bahU20ny8v34USCkJJhlQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    gitpython
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyexploitdb" ];

  meta = {
    description = "Library to fetch the most recent exploit-database";
    homepage = "https://github.com/Hackman238/pyExploitDb";
    changelog = "https://github.com/Hackman238/pyExploitDb/blob/master/ChangeLog.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
