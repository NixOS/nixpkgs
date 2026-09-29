{
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "capirca";
    tag = "v${finalAttrs.version}";
    hash = "sha256-huCh7nKr8s6LJBE9LLOqGCdq9t7RON8TTBhs5ti9j58=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/google/capirca/commit/9b16efdc2aa3df748c47ac0a5afe7d32b9467d14.patch";
      hash = "sha256-9SagnIuwd/3xY/K77y+f/HJqyxRRzWvaBUnq4O2uXek=";
    })
    (fetchpatch {
      url = "https://github.com/google/capirca/commit/e5bda6a0b0e8bb6d8c66ac8f4b17e93350266a81.patch";
      hash = "sha256-vUbSaaPlDU5DpXbvOGXFachIQ2JRfNYpj0/80r67geM=";
    })
  ];

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
