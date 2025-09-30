{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-json-logger";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nhairs";
    repo = "python-json-logger";
    tag = "v${version}";
    hash = "sha256-q1s+WRU5xTmF4YW20DrDnXbMeW6vGYzVekxxIDVt8gw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  disabledTests =
    lib.optionals (pythonAtLeast "3.12") [
      # https://github.com/madzak/python-json-logger/issues/185
      "test_custom_object_serialization"
      "test_percentage_format"
      "test_rename_reserved_attrs"
    ]
    ++ lib.optionals (pythonAtLeast "3.13") [
      # https://github.com/madzak/python-json-logger/issues/198
      "test_json_default_encoder_with_timestamp"
    ];

  meta = with lib; {
    description = "Json Formatter for the standard python logger";
    homepage = "https://github.com/madzak/python-json-logger";
    license = licenses.bsdOriginal;
    maintainers = [ ];
  };
}
