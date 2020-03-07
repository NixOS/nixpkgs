{ buildPythonPackage
, fetchPypi
, h5py
, numpy
, dill
, astropy
, scipy
, pandas
, pytest
, pytestcov
, pytestrunner
, coveralls
, lib
}:

buildPythonPackage rec {
  pname   = "hickle";
  version = "3.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d1qj3yl7635lgkqacz9r8fyhv71396l748ww4wy05ibpignjm2x";
  };

  postPatch = ''
    substituteInPlace requirements_test.txt \
      --replace 'astropy<3.1;' 'astropy;' --replace 'astropy<3.0;' 'astropy;'
  '';

  propagatedBuildInputs = [ h5py numpy dill ];
  checkInputs = [ pytest pytestcov pytestrunner coveralls scipy pandas astropy ];

  meta = {
    description = "Serialize Python data to HDF5";
    homepage = "https://github.com/telegraphic/hickle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
