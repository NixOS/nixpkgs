{ lib
, buildPythonPackage
, fetchPypi
, pyparsing
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aenum";
  version = "3.1.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PlMckYYKgfiF9+bpfSGa6XcsuJlYAIR4iTXa19l0LvA=";
  };

  nativeCheckInputs = [
    pyparsing
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aenum"
  ];

  disabledTests = [
    # https://github.com/ethanfurman/aenum/issues/27
    "test_class_nested_enum_and_pickle_protocol_four"
    "test_pickle_enum_function_with_qualname"
    "test_stdlib_inheritence"
    "test_subclasses_with_getnewargs_ex"
    "test_arduino_headers"
    "test_c_header_scanner"
    "test_extend_flag_backwards_stdlib"
  ];

  meta = with lib; {
    description = "Advanced Enumerations (compatible with Python's stdlib Enum), NamedTuples, and NamedConstants";
    homepage = "https://github.com/ethanfurman/aenum";
    license = licenses.bsd3;
    maintainers = with maintainers; [ vrthra ];
  };
}
