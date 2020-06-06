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
  version = "3.0.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "40cc615801c8876306af1009a312f9c90752f1d79610fc1146917585b6f374dd";
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
