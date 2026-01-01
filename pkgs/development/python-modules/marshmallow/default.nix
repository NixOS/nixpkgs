{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  pythonOlder,

  # build-system
  flit-core,

  # dependencies
  backports-datetime-fromisoformat,
  typing-extensions,

  # tests
=======
  flit-core,
  packaging,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytestCheckHook,
  simplejson,
}:

buildPythonPackage rec {
  pname = "marshmallow";
<<<<<<< HEAD
  version = "4.1.2";
=======
  version = "3.26.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "marshmallow";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-qEjq1tEWoYqlN7L/cECnpFGPinSdZXexJHZfXreLAZc=";
  };

  build-system = [ flit-core ];

  dependencies = lib.optionals (pythonOlder "3.11") [
    backports-datetime-fromisoformat
    typing-extensions
  ];
=======
    hash = "sha256-l5pEhv8D6jRlU24SlsGQEkXda/b7KUdP9mAqrZCbl38=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ packaging ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeCheckInputs = [
    pytestCheckHook
    simplejson
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isx86_32 [
    # Raises a slightly different error than upstream expects: 'Timestamp is too large' instead of 'out of range'
    "test_from_timestamp_with_overflow_value"
  ];

  pythonImportsCheck = [ "marshmallow" ];

<<<<<<< HEAD
  meta = {
    description = "Library for converting complex objects to and from simple Python datatypes";
    homepage = "https://github.com/marshmallow-code/marshmallow";
    changelog = "https://github.com/marshmallow-code/marshmallow/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cript0nauta ];
=======
  meta = with lib; {
    description = "Library for converting complex objects to and from simple Python datatypes";
    homepage = "https://github.com/marshmallow-code/marshmallow";
    changelog = "https://github.com/marshmallow-code/marshmallow/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ cript0nauta ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
