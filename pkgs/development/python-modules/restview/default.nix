{ lib
, buildPythonPackage
, fetchPypi
, docutils
, readme-renderer
, packaging
, pygments
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "restview";
  version = "3.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jBoXHBWdRtFdVWn3cCGCiIOhIdb5uvdY1kH8HlSwWuU=";
  };

  propagatedBuildInputs = [
    docutils
    readme-renderer
    packaging
    pygments
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "restview"
  ];

  disabledTests = [
    # Tests are comparing output
    "rest_to_html"
  ];

  meta = with lib; {
    description = "ReStructuredText viewer";
    homepage = "https://mg.pov.lt/restview/";
    changelog = "https://github.com/mgedmin/restview/blob/${version}/CHANGES.rst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ koral ];
  };
}
