{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-system
  flit-core,

  # dependencies
  packaging,

  # tests
  pytestCheckHook,
  simplejson,
}:

# Kept for packages that do not support marshmallow 4 yet, such as azure-ai-ml
buildPythonPackage (finalAttrs: {
  pname = "marshmallow";
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
    # Expects an error message that Python 3.14 words differently
    "test_from_timestamp_with_overflow_value"
  ];

  pythonImportsCheck = [ "marshmallow" ];

  passthru = {
    # The bulk updater would move this to marshmallow 4
    skipBulkUpdate = true;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^(3\\..*)$"
      ];
    };
  };

  meta = {
    description = "Library for converting complex objects to and from simple Python datatypes";
    homepage = "https://github.com/marshmallow-code/marshmallow";
    changelog = "https://github.com/marshmallow-code/marshmallow/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takishima ];
  };
})
