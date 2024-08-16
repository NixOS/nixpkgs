{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysdcp";
  version = "1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "pySDCP";
    inherit version;
    sha256 = "07396lsn610izaravqc6j5f6m0wjrzgc0d1r9dwqzj15g5zfc7wm";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysdcp" ];

  meta = with lib; {
    description = "Python library to control SONY projectors";
    homepage = "https://github.com/Galala7/pySDCP";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
