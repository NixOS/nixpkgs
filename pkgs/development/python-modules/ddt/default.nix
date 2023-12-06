{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools

# tests
, aiounittest
, mock
, pytestCheckHook
, pyyaml
, six
}:

buildPythonPackage rec {
  pname = "ddt";
  version = "1.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0XjRFavyWhuDJ+lPhaA+8JsdewyiVvYgMoSwJPL8cN8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # aiounittest is not compatible with Python 3.12.
  doCheck = pythonOlder "3.12";

  nativeCheckInputs = [
    aiounittest
    mock
    pytestCheckHook
    pyyaml
    six
  ];

  meta = with lib; {
    changelog = "https://github.com/datadriventests/ddt/releases/tag/${version}";
    description = "Data-Driven/Decorated Tests, a library to multiply test cases";
    homepage = "https://github.com/txels/ddt";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
