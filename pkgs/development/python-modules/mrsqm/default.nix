{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cython
, fftw
, pandas
, scikit-learn
, numpy
}:

buildPythonPackage rec {
  pname = "mrsqm";
  version = "0.0.6";
  format = "setuptools";

  disable = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dBwWiJEL76aXqM2vKn4uQsd86Rm3bMeDSsRRs/aLWCE=";
  };

  buildInputs = [ fftw ];

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    pandas
    scikit-learn
    numpy
  ];

  doCheck = false; # Package has no tests
  pythonImportsCheck = [ "mrsqm" ];

  meta = with lib; {
    description = "MrSQM (Multiple Representations Sequence Miner) is a time series classifier";
    homepage = "https://pypi.org/project/mrsqm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
