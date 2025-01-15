{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  matplotlib,
  numpy,
  scipy,
  librosa,
  tqdm,
  torch,
}:
buildPythonPackage rec {
  pname = "noisereduce";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timsainb";
    repo = "noisereduce";
    rev = "v${version}";
    hash = "sha256-+49vVD242hjOr05z8FNvwHhcUJHWglqKrEkwDX7OMXU=";
  };

  postPatch = ''
    # fix import check
    # fix: cannot cache function 'x': no locator available
    export NUMBA_CACHE_DIR=$TMP
  '';

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    librosa
    tqdm
    matplotlib
  ];

  optional-dependencies = {
    PyTorch = [ torch ];
  };

  pythonImportsCheck = [ "noisereduce" ];

  meta = {
    description = "Noise reduction in python using spectral gating";
    homepage = "https://github.com/timsainb/noisereduce";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hakan-demirli ];
  };
}
