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
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "markupsafe";
    rev = "refs/tags/${version}";
    hash = "sha256-YMvEfrIwGy5Ug4EjkiWOlijEWltWSjJGDrpseH86778=";
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

  meta = with lib; {
    changelog = "https://markupsafe.palletsprojects.com/page/changes/#version-${
      replaceStrings [ "." ] [ "-" ] version
    }";
    description = "Implements a XML/HTML/XHTML Markup safe string";
    homepage = "https://palletsprojects.com/p/markupsafe/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };
}
