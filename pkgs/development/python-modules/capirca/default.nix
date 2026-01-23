{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build system
  setuptools,

  # dependencies
  absl-py,
  ply,
  pyyaml,

  # test dependencies
  pytestCheckHook,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "capirca";
  version = "2.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "capirca";
    tag = "v${finalAttrs.version}";
    hash = "sha256-huCh7nKr8s6LJBE9LLOqGCdq9t7RON8TTBhs5ti9j58=";
  };

  build-system = [ setuptools ];

  dependencies = [
    absl-py
    ply
    pyyaml
  ];

  pythonRemoveDeps = [
    "mock" # unused dependency
    "six" # test dependency
  ];

  pythonImportsCheck = [ "capirca" ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];
  disabledTests = [
    # AttributeError: 'has_calls' is not a valid assertion. Use a spec for the mock if 'has_calls' is meant to be an attribute.
    "testMissingMatchCriteria"
  ];

  meta = {
    description = "Multi-platform ACL generation system";
    homepage = "https://github.com/google/capirca";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
