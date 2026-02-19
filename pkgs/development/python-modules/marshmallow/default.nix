{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # tests
  pytestCheckHook,
  simplejson,
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "4.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "marshmallow";
    tag = version;
    hash = "sha256-qEjq1tEWoYqlN7L/cECnpFGPinSdZXexJHZfXreLAZc=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
    simplejson
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isx86_32 [
    # Raises a slightly different error than upstream expects: 'Timestamp is too large' instead of 'out of range'
    "test_from_timestamp_with_overflow_value"
  ];

  pythonImportsCheck = [ "marshmallow" ];

  meta = {
    description = "Library for converting complex objects to and from simple Python datatypes";
    homepage = "https://github.com/marshmallow-code/marshmallow";
    changelog = "https://github.com/marshmallow-code/marshmallow/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cript0nauta ];
  };
}
