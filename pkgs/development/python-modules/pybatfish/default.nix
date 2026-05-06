{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build system
  setuptools,

  # dependencies
  attrs,
  deepdiff,
  pandas,
  python-dateutil,
  pyyaml,
  requests,
  requests-toolbelt,
  simplejson,
  urllib3,

  # optional dependencies
  absl-py,
  capirca,

  # test dependencies
  pytest-cov,
  pytestCheckHook,
  responses,
}:

buildPythonPackage (finalAttrs: {
  pname = "pybatfish";
  version = "2025.07.07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "batfish";
    repo = "pybatfish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rjR/VgEwBAtINk1f0aGmO63OMzWuFgYiC7puLazTqBY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    attrs
    deepdiff
    pandas
    python-dateutil
    pyyaml
    requests
    requests-toolbelt
    simplejson
    urllib3
  ];

  optional-dependencies = {
    capirca = [
      absl-py
      capirca
    ];
  };

  pythonImportsCheck = [ "pybatfish" ];

  nativeCheckInputs = [
    pytest-cov
    pytestCheckHook
    responses
  ]
  ++ finalAttrs.passthru.optional-dependencies.capirca;

  meta = {
    description = "Python client for Batfish";
    homepage = "https://github.com/batfish/pybatfish";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
