{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyparsing,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aenum";
  version = "3.1.16";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v6+Vib20GO46mG2FdQxzGNnSg5wbGh1v6PxT7CAc8UA=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pyparsing
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aenum" ];

  disabledTests = [
    # https://github.com/ethanfurman/aenum/issues/27
    "test_class_nested_enum_and_pickle_protocol_four"
    "test_pickle_enum_function_with_qualname"
    "test_stdlib_inheritence"
    "test_subclasses_with_getnewargs_ex"
    "test_arduino_headers"
    "test_c_header_scanner"
    "test_extend_flag_backwards_stdlib"
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    # AttributeError: <enum 'Color'> has no attribute 'value'. Did you mean: 'blue'?
    "test_extend_enum_shadow_property_stdlib"
  ];

  meta = {
    description = "Advanced Enumerations (compatible with Python's stdlib Enum), NamedTuples, and NamedConstants";
    homepage = "https://github.com/ethanfurman/aenum";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
