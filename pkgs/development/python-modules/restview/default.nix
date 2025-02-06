{
  lib,
  buildPythonPackage,
  docutils,
  fetchPypi,
  packaging,
  pygments,
  pytestCheckHook,
  pythonOlder,
  readme-renderer,
  setuptools,
}:

buildPythonPackage rec {
  pname = "restview";
  version = "3.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i011oL7Xa2e0Vu9wEfTrbJilVsn4N2Qt8iAscxL8zBo=";
  };

  pythonRelaxDeps = [ "readme-renderer" ];

  build-system = [ setuptools ];

  dependencies = [
    docutils
    readme-renderer
    packaging
    pygments
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "restview" ];

  disabledTests = [
    # Tests are comparing output
    "rest_to_html"
  ];

  meta = with lib; {
    description = "ReStructuredText viewer";
    homepage = "https://mg.pov.lt/restview/";
    changelog = "https://github.com/mgedmin/restview/blob/${version}/CHANGES.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ koral ];
    mainProgram = "restview";
  };
}
