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

  disabled = pythonOlder "3.8";

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

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "mrsqm" ];

  meta = with lib; {
    description = "MrSQM (Multiple Representations Sequence Miner) is a time series classifier";
    homepage = "https://pypi.org/project/mrsqm";
    changelog = "https://github.com/mlgig/mrsqm/releases/tag/v.${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
