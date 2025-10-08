{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  meson-python,
  packaging,
  cython,
  numpy,
  scipy,
  h5py,
  nibabel,
  tqdm,
  trx-python,
}:

buildPythonPackage rec {
  pname = "dipy";
  version = "1.11.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "dipy";
    repo = "dipy";
    tag = version;
    hash = "sha256-vqjd5gd9B630pv6H4MvXnlPwlEhm1o7MbwYD0J7D24o=";
  };

  build-system = [
    cython
    meson-python
    numpy
    packaging
  ];

  dependencies = [
    numpy
    scipy
    h5py
    nibabel
    packaging
    tqdm
    trx-python
  ];

  # disable tests for now due to:
  #   - some tests require data download (see dipy/dipy/issues/2092);
  #   - running the tests manually causes a multiprocessing hang;
  #   - import weirdness when running the tests
  doCheck = false;

  pythonImportsCheck = [
    "dipy"
    "dipy.core"
    "dipy.direction"
    "dipy.tracking"
    "dipy.reconst"
    "dipy.io"
    "dipy.viz"
    "dipy.data"
    "dipy.utils"
    "dipy.segment"
    "dipy.sims"
    "dipy.stats"
    "dipy.denoise"
    "dipy.workflows"
    "dipy.nn"
  ];

  meta = {
    homepage = "https://dipy.org/";
    description = "Diffusion imaging toolkit for Python";
    changelog = "https://github.com/dipy/dipy/blob/${version}/Changelog";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
