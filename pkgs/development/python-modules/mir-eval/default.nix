{
  lib,
  buildPythonPackage,
  fetchPypi,
  future,
  six,
  numpy,
  scipy,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "mir-eval";
  version = "0.8.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "mir_eval";
    inherit version;
    hash = "sha256-FBo+EZMnaIn8MukRVH5z3LPoKe6M/qYPe7zWM8B5JWk=";
  };

  propagatedBuildInputs = [
    future
    six
    numpy
    scipy
    matplotlib
  ];

  pythonImportsCheck = [ "mir_eval" ];

  meta = with lib; {
    description = "Common metrics for common audio/music processing tasks";
    homepage = "https://github.com/craffel/mir_eval";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
