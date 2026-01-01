{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  typing-extensions,
<<<<<<< HEAD
  cron-converter,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  semver,
  pendulum,
  phonenumbers,
  pycountry,
  pymongo,
  python-ulid,
  pytz,
<<<<<<< HEAD
  tzdata,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pydantic-extra-types";
<<<<<<< HEAD
  version = "2.10.6";
=======
  version = "2.10.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-extra-types";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-g2a7tfldt39RCZxd9ta/JTPYnfZTTsLE6kA2fuo3fFg=";
=======
    hash = "sha256-05yGIAgN/sW+Nj7F720ZAHeMz/AyvwHMfzp4OdLREe4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  dependencies = [
    pydantic
    typing-extensions
  ];

  optional-dependencies = {
    all = [
<<<<<<< HEAD
      cron-converter
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      pendulum
      phonenumbers
      pycountry
      pymongo
      python-ulid
      pytz
      semver
<<<<<<< HEAD
      tzdata
    ];
    cron = [ cron-converter ];
=======
    ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    phonenumbers = [ phonenumbers ];
    pycountry = [ pycountry ];
    semver = [ semver ];
    python_ulid = [ python-ulid ];
    pendulum = [ pendulum ];
  };

<<<<<<< HEAD
  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTests = [
    # https://github.com/pydantic/pydantic-extra-types/issues/346
    "test_json_schema"
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pythonImportsCheck = [ "pydantic_extra_types" ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.all;

  # PermissionError accessing '/etc/localtime'
  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [ "tests/test_pendulum_dt.py" ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/pydantic/pydantic-extra-types/blob/${src.tag}/HISTORY.md";
    description = "Extra Pydantic types";
    homepage = "https://github.com/pydantic/pydantic-extra-types";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://github.com/pydantic/pydantic-extra-types/blob/${src.tag}/HISTORY.md";
    description = "Extra Pydantic types";
    homepage = "https://github.com/pydantic/pydantic-extra-types";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
