{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, packaging
, pytest
, nose
, numpy
, h5py
, pydicom
, scipy
}:

buildPythonPackage rec {
  pname = "nibabel";
  version = "3.2.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4d2ff9426b740011a1c916b54fc25da9348282e727eaa2ea163f42e00f1fc29e";
  };

  propagatedBuildInputs = [ numpy scipy h5py packaging pydicom ];

  checkInputs = [ nose pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://nipy.org/nibabel";
    description = "Access a multitude of neuroimaging data formats";
    license = licenses.mit;
    maintainers = with maintainers; [ ashgillman ];
  };
}
