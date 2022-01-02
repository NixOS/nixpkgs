{ lib
, buildPythonPackage
, fetchPypi
, docutils
, readme_renderer
, packaging
, pygments
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "restview";
  version = "2.9.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-WVGqIYLnqao6uQbb0PDTPfj+k+ZjGKholknBIorXTNg=";
  };

  propagatedBuildInputs = [
    docutils
    readme_renderer
    packaging
    pygments
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "restview"
  ];

  meta = {
    description = "ReStructuredText viewer";
    homepage = "https://mg.pov.lt/restview/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ koral ];
  };
}
