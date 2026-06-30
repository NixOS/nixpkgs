{
  lib,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  soundfile,
  scipy,
  ordered-set,
  tqdm,
  numpy,
  pandas,
  psutil,
  pyarrow,
  kagglehub,
  tensorflow,
  pytest-cov-stub,
  pytest-xdist,
  pytest-timeout,
}:
buildPythonPackage (finalAttrs: {
  pname = "birdnet";
  version = "0.2.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "birdnet-team";
    repo = "birdnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xHXuo50rx+xQoyWgr06VXkL2CnZhfvRqwzqeAcj8d9g=";
  };

  __structuredAttrs = true;

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  dependencies = [
    soundfile
    scipy
    ordered-set
    tqdm
    numpy
    pandas
    psutil
    pyarrow
    kagglehub
    tensorflow
  ];

  # Tries to download model weights during tests
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    pytest-cov-stub
    pytest-xdist
    pytest-timeout
  ];

  pythonImportsCheck = [
    "birdnet"
  ];

  meta = {
    homepage = "https://birdnet.cornell.edu/birdnet";
    downloadPage = "https://github.com/birdnet-team/birdnet/releases";
    changelog = "https://github.com/birdnet-team/birdnet/releases/tag/v${finalAttrs.version}";
    license = [
      lib.licenses.mit
    ];
    maintainers = [
      lib.maintainers.RossSmyth
    ];
  };
})
