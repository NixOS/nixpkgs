{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  typing-extensions,
  cron-converter,
  jsonschema,
  semver,
  pendulum,
  phonenumbers,
  pycountry,
  pymongo,
  python-ulid,
  pytz,
  tzdata,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pydantic-extra-types";
  version = "2.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-extra-types";
    tag = "v${version}";
    hash = "sha256-O8pw9oX+7hthg4/WtPAQXFwXT6qqan0xRGlE2Er7gtk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pydantic
    typing-extensions
  ];

  optional-dependencies = {
    all = [
      cron-converter
      jsonschema
      pendulum
      phonenumbers
      pycountry
      pymongo
      python-ulid
      pytz
      semver
      tzdata
    ];
    cron = [ cron-converter ];
    phonenumbers = [ phonenumbers ];
    pycountry = [ pycountry ];
    semver = [ semver ];
    python_ulid = [ python-ulid ];
    pendulum = [ pendulum ];
  };

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    # https://github.com/pydantic/pydantic-extra-types/issues/346
    "test_json_schema"
  ];

  pythonImportsCheck = [ "pydantic_extra_types" ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.all;

  # PermissionError accessing '/etc/localtime'
  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [ "tests/test_pendulum_dt.py" ];

  meta = {
    changelog = "https://github.com/pydantic/pydantic-extra-types/blob/${src.tag}/HISTORY.md";
    description = "Extra Pydantic types";
    homepage = "https://github.com/pydantic/pydantic-extra-types";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
