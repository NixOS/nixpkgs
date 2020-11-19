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
  version = "3.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5827b644d1b0833603710dac198f5f8cbb9002769f97001a191e863b32f5956c";
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
    platforms = platforms.x86_64;  # https://github.com/nipy/nibabel/issues/861
  };
}
