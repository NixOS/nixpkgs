{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, packaging
, pytest
, cython
, numpy
, scipy
, h5py
, nibabel
, tqdm
}:

buildPythonPackage rec {
  pname = "dipy";
  version = "1.3.0";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner  = "dipy";
    repo   = pname;
    rev    = version;
    sha256 = "0555abx0fwqmk6dc3im7r45d9j7r9xh6gm9mbwfwvlf7laf8h098";
  };

  nativeBuildInputs = [ cython packaging ];
  propagatedBuildInputs = [
    numpy
    scipy
    h5py
    nibabel
    tqdm
  ];

  checkInputs = [ pytest ];

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
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
