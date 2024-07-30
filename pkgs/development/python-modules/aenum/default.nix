{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyparsing,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aenum";
  version = "3.1.15";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jL12zRjE+HD/ObJChNPqAo++hzGljfOqWB5DTFdblVk=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pyparsing
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aenum" ];

  disabledTests =
    [
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

  meta = with lib; {
    description = "Advanced Enumerations (compatible with Python's stdlib Enum), NamedTuples, and NamedConstants";
    homepage = "https://github.com/ethanfurman/aenum";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
