{ lib
, buildPythonPackage
, fetchPypi
, docutils
, readme_renderer
, packaging
, pygments
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "restview";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-K5iWEKrtL9Qtpk9s3FOc8+5wzjcLy6hy23JCGtUV3R4=";
  };

  propagatedBuildInputs = [
    docutils
    readme_renderer
    packaging
    pygments
  ];

  checkInputs = [
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
