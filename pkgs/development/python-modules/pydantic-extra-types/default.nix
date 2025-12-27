{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  typing-extensions,
  semver,
  pendulum,
  phonenumbers,
  pycountry,
  pymongo,
  python-ulid,
  pytz,
  pytestCheckHook,
  cron-converter,
}:

buildPythonPackage rec {
  pname = "pydantic-extra-types";
  version = "2.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-extra-types";
    tag = "v${version}";
    hash = "sha256-aXhlfDBCpk8h3F4gXAQ40fVKxsoFvkmfO/roaqrGxho=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pydantic
    typing-extensions
  ];

  optional-dependencies = {
    all = [
      pendulum
      phonenumbers
      pycountry
      pymongo
      python-ulid
      pytz
      semver
      cron-converter
    ];
    phonenumbers = [ phonenumbers ];
    pycountry = [ pycountry ];
    semver = [ semver ];
    python_ulid = [ python-ulid ];
    pendulum = [ pendulum ];
    cron = [ cron-converter ];
  };

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
