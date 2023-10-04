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
  version = "0.0.5";
  format = "setuptools";

  disable = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VlAbyTWQCj6fgndEPI1lQKvL+D6TJnqglIT8dRZyEWc=";
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
