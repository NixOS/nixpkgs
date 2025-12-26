{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

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
  version = "3.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "markupsafe";
    tag = version;
    hash = "sha256-2d64cItemqVM25WJIKrjExKz6v4UW2wVxM6phH1g1sE=";
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
