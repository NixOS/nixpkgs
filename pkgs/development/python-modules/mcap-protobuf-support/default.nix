{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mcap,
  protobuf,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mcap-protobuf-support";
  version = "0.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "foxglove";
    repo = "mcap";
    tag = "releases/python/mcap-protobuf-support/v${finalAttrs.version}";
    hash = "sha256-BBS1M9LDBas7B0h9GB/r4fBrRcF1WAcXhWlX1J9+wmA=";
  };

  sourceRoot = "${finalAttrs.src.name}/python/mcap-protobuf-support";

  build-system = [ setuptools ];

  dependencies = [
    mcap
    protobuf
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mcap_protobuf" ];

  meta = {
    description = "Protobuf support for the Python MCAP library";
    homepage = "https://github.com/foxglove/mcap";
    changelog = "https://github.com/foxglove/mcap/releases/tag/releases%2Fpython%2Fmcap-protobuf-support%2Fv${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jfr ];
  };
})
