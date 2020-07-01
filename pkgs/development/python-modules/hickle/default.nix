{ buildPythonPackage
, fetchPypi
, h5py
, numpy
, dill
, astropy
, scipy
, pandas
, codecov
, pytest
, pytestcov
, pytestrunner
, coveralls
, twine
, check-manifest
, lib
}:

buildPythonPackage rec {
  pname   = "hickle";
  version = "3.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "026r6yg3amsi8k8plzsbw5rnifym6sc17y011daqyvcpb7mfs94b";
  };

  postPatch = ''
    substituteInPlace requirements_test.txt \
      --replace 'astropy<3.1;' 'astropy;' --replace 'astropy<3.0;' 'astropy;'
  '';

  propagatedBuildInputs = [ h5py numpy dill ];
  checkInputs = [
    pytest pytestcov pytestrunner coveralls scipy pandas astropy twine check-manifest codecov
  ];

  meta = {
    description = "Serialize Python data to HDF5";
    homepage = "https://github.com/telegraphic/hickle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
