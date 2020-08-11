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
  version = "3.1.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kir9g7kmy2qygyzczx8nj4b0sc6jjvqy0ssm39bxzqsr1vzzvxm";
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
