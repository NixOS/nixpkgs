{ lib
, buildPythonPackage
, fetchPypi
, future
, six
, numpy
, scipy
, matplotlib
}:

buildPythonPackage rec {
  pname = "mir_eval";
  version = "0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4f66pXZsZadUXCoXCyQUkPR6mJhzcLHgZ0JCTF3r5l4=";
  };

  propagatedBuildInputs = [
    future
    six
    numpy
    scipy
    matplotlib
  ];

  pythonImportsCheck = [
    "mir_eval"
  ];

  meta = with lib; {
    description = "Common metrics for common audio/music processing tasks";
    homepage = "https://github.com/craffel/mir_eval";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
