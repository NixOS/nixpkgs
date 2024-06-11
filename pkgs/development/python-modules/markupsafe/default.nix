{
  lib,
  buildPythonPackage,
  fetchPypi,
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
  version = "2.1.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "MarkupSafe";
    inherit version;
    hash = "sha256-0oPTeokLpMGuc/+t+ARkNcdue8Ike7tjwAvRpwnGVEs=";
  };

  nativeBuildInputs = [ setuptools ];

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
    changelog = "https://markupsafe.palletsprojects.com/en/${versions.majorMinor version}.x/changes/#version-${
      replaceStrings [ "." ] [ "-" ] version
    }";
    description = "Implements a XML/HTML/XHTML Markup safe string";
    homepage = "https://palletsprojects.com/p/markupsafe/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };
}
