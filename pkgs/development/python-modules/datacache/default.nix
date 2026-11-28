{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  argcomplete,
  filelock,
  pandas,
  platformdirs,
  requests,
  tqdm,

  # optional-dependencies
  lxml,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "datacache";
  version = "1.40.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openvax";
    repo = "datacache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-44RawVEmGirJeXXmMiIhoGt0XDWveC/9uEYsHcE9iiQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    argcomplete
    filelock
    pandas
    platformdirs
    requests
    tqdm
  ];

  optional-dependencies = {
    html = [ lxml ];
  };

  pythonImportsCheck = [ "datacache" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  # Tests spin up a local HTTP server
  __darwinAllowLocalNetworking = true;

  disabledTests = [
    # AttributeError: module 'os' has no attribute 'getuid'
    # (the test removes `os.getuid` and `getpass` falls back on it, as `$USER` is unset in the sandbox)
    "test_users_are_told_apart_without_numeric_ids"
  ];

  meta = {
    description = "Helpers for transparently downloading datasets";
    homepage = "https://github.com/openvax/datacache";
    changelog = "https://github.com/openvax/datacache/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "datacache";
  };
})
