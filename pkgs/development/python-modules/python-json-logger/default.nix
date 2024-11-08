{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "python-json-logger";
  version = "2.0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I+fsAtNCN8WqHimgcBk6Tqh1g7tOf4/QbT3oJkxLLhw=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # https://github.com/madzak/python-json-logger/issues/185
    "test_custom_object_serialization"
    "test_percentage_format"
    "test_rename_reserved_attrs"
  ];

  meta = with lib; {
    description = "Json Formatter for the standard python logger";
    homepage = "https://github.com/madzak/python-json-logger";
    license = licenses.bsdOriginal;
    maintainers = [ ];
  };
}
