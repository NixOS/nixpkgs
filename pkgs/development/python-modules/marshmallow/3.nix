{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  packaging,

  # tests
  pytestCheckHook,
  simplejson,
}:

buildPythonPackage (finalAttrs: {
  pname = "marshmallow";
  # nixpkgs-update: no auto update
  version = "3.26.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "marshmallow";
    tag = finalAttrs.version;
    hash = "sha256-ioe+aZHOW8r3wF3UknbTjAP0dEggd/NL9PTkPVQ46zM=";
  };

  build-system = [ flit-core ];

  dependencies = [ packaging ];

  nativeCheckInputs = [
    pytestCheckHook
    simplejson
  ];

  disabledTests = [
    # 'year must be in 1..9999, not 292278994' instead of 'out of range'
    "test_from_timestamp_with_overflow_value"
  ];

  pythonImportsCheck = [ "marshmallow" ];

  passthru.skipBulkUpdate = true;

  meta = {
    description = "Library for converting complex objects to and from simple Python datatypes";
    homepage = "https://github.com/marshmallow-code/marshmallow";
    changelog = "https://github.com/marshmallow-code/marshmallow/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bryanhonof ];
  };
})
