{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, poetry-core
, numpy
, orjson
, pydantic
, rich
, types-requests
, typing-inspect
, pytestCheckHook
, pytest-cov
,
}:
buildPythonPackage rec {
  pname = "docarray";
  version = "0.40.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-w/O4i3thKMEDCN3b0hZQyYReJw2oUM9nGMsdPYZ9WYY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    numpy
    orjson
    pydantic
    rich
    types-requests
    typing-inspect
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [
    "docarray"
  ];

  meta = with lib; {
    description = "Library expertly crafted for the representation, transmission, storage, and retrieval of multimodal data";
    homepage = "https://docs.docarray.org/";
    changelog = "https://github.com/docarray/docarray/blob/main/CHANGELOG.md";
    licence = licenses.apache2;
    maintainers = with maintainers; [ loicreynier ];
  };
}
