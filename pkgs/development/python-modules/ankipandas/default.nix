{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pandas
, colorlog
, pytest
, pytest-cov
, randomfiletree
}:

buildPythonPackage rec {
  pname = "ankipandas";
  version = "0.3.15";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-31kkXytwUHeua6TBZMyfuvmQa9KNKcK/ielwDqNj37w=";
  };

  propagatedBuildInputs = [
    numpy
    pandas
    colorlog
  ];

  pythonImportsCheck = [ "ankipandas" ];

  nativeCheckInputs = [ pytest pytest-cov randomfiletree ];
  doCheck = true;
  preCheck = ''
  # Resolve OSError: [Errno 24] Too many open files: '/build/tmpr5xzzy53'
  ulimit -n 2048
  '';
  checkPhase = ''
    runHook preCheck
    pytest
    runHook postCheck
  '';

  meta = with lib; {
    description = "Load your anki database as a pandas DataFrame with just one line of code";
    homepage = "https://pypi.org/project/ankipandas/";
    license = licenses.mit;
    maintainers = with maintainers; [ twitchy0 ];
  };
}
