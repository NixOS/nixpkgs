{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  packaging,
  pytestCheckHook,
  simplejson,
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "3.26.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "marshmallow";
    tag = version;
    hash = "sha256-ioe+aZHOW8r3wF3UknbTjAP0dEggd/NL9PTkPVQ46zM=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ packaging ];

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
