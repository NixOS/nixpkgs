{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,

  # reverse dependencies
  jinja2,
  mkdocs,
  quart,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "markupsafe";
  version = "3.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "markupsafe";
    tag = version;
    hash = "sha256-RDjYVW0YlYVlha5cBcB7zjNN3zO3xS92DUhYJsNusfk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "markupsafe" ];

  passthru.tests = {
    inherit
      jinja2
      mkdocs
      quart
      werkzeug
      ;
  };

  meta = {
    changelog = "https://markupsafe.palletsprojects.com/page/changes/#version-${
      lib.replaceStrings [ "." ] [ "-" ] version
    }";
    description = "Implements a XML/HTML/XHTML Markup safe string";
    homepage = "https://palletsprojects.com/p/markupsafe/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
