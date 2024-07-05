{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  packaging,
  cython,
  numpy,
  scipy,
  h5py,
  nibabel,
  tqdm,
}:

buildPythonPackage rec {
  pname = "dipy";
  version = "1.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "dipy";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-sfqCK2r9Io1gDDHL9s9R37J0h9KcOQML3B2zJx2+QuA=";
  };

  nativeBuildInputs = [
    cython
    packaging
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    h5py
    nibabel
    tqdm
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
    "dipy.boots"
    "dipy.data"
    "dipy.utils"
    "dipy.segment"
    "dipy.sims"
    "dipy.stats"
    "dipy.denoise"
    "dipy.workflows"
    "dipy.nn"
  ];

  meta = with lib; {
    homepage = "https://dipy.org/";
    description = "Diffusion imaging toolkit for Python";
    changelog = "https://github.com/dipy/dipy/blob/${version}/Changelog";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
