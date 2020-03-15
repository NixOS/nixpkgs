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
  version = "3.0.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "08nlny8vzkpjpyb0q943cq57m2s4wndm86chvd3d5qvar9z6b36k";
  };

  propagatedBuildInputs = [ numpy scipy h5py pydicom ];

  checkInputs = [ nose pytest ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = https://nipy.org/nibabel/;
    description = "Access a multitude of neuroimaging data formats";
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
    platforms = platforms.x86_64;  # https://github.com/nipy/nibabel/issues/861
  };
}
