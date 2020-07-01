{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, nose
, pytest
, numpy
, h5py
, pydicom
, scipy
}:

buildPythonPackage rec {
  pname = "nibabel";
  version = "3.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "774adcff834f22915afb68c6cdd7acbcb5d0240b7f87f6da6c63ff405480884b";
  };

  propagatedBuildInputs = [ numpy scipy h5py pydicom ];

  checkInputs = [ nose pytest ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = "https://nipy.org/nibabel";
    description = "Access a multitude of neuroimaging data formats";
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
    platforms = platforms.x86_64;  # https://github.com/nipy/nibabel/issues/861
  };
}
