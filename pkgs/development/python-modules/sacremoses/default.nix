{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  click,
  joblib,
  regex,
  tqdm,
  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sacremoses";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hplt-project";
    repo = "sacremoses";
    tag = finalAttrs.version;
    sha256 = "sha256-ked6/8oaGJwVW1jvpjrWtJYfr0GKUHdJyaEuzid/S3M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    joblib
    regex
    tqdm
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  # ignore tests which call to remote host
  disabledTestPaths = [
    "sacremoses/test/test_truecaser.py::TestTruecaser"
  ];

  meta = {
    homepage = "https://github.com/alvations/sacremoses";
    description = "Python port of Moses tokenizer, truecaser and normalizer";
    mainProgram = "sacremoses";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pashashocky ];
  };
})
