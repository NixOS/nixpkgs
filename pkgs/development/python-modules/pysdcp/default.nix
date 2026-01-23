{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pysdcp";
  version = "1";
  format = "setuptools";

  src = fetchPypi {
    pname = "pySDCP";
    inherit version;
    sha256 = "07396lsn610izaravqc6j5f6m0wjrzgc0d1r9dwqzj15g5zfc7wm";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysdcp" ];

  meta = {
    description = "Python library to control SONY projectors";
    homepage = "https://github.com/Galala7/pySDCP";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
