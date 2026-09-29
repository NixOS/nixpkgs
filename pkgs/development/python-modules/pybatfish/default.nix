{
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.36.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "batfish";
    repo = "pybatfish";
    tag = "v2025.07.07";
    hash = "sha256-rjR/VgEwBAtINk1f0aGmO63OMzWuFgYiC7puLazTqBY=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/batfish/pybatfish/commit/f3e49aa456b53130a3d0b832d1306abbd17425cd.patch";
      hash = "sha256-3fU5FYkiPAqgsZ6bNHs/RroHD8Ic8dJyO6X8xL3c61U=";
    })
  ];

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
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  meta = {
    description = "Python API and utilities for Batfish";
    homepage = "https://github.com/batfish/pybatfish";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
