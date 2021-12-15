{ lib
, bleach
, buildPythonPackage
, cmarkgfm
, docutils
, fetchPypi
, future
, mock
, pygments
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "readme-renderer";
  version = "32.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "readme_renderer";
    inherit version;
    sha256 = "sha256-tRK+r6Z5gmDH1a8+Gx8Jfli/zZpXXafE3dXgN0kKW4U=";
  };

  propagatedBuildInputs = [
    bleach
    cmarkgfm
    docutils
    future
    pygments
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "readme_renderer"
  ];

  meta = with lib; {
    description = "Python library for rendering readme descriptions";
    homepage = "https://github.com/pypa/readme_renderer";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
