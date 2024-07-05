{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pysingleton";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5776e7a4ba0bab26709da604f4e648c5814385fef34010723db3da0d41b0dbcc";
  };

  pythonImportsCheck = [ "singleton" ];

  # No tests in the Pypi package.
  doCheck = false;

  meta = with lib; {
    description = "Provides a decorator to create thread-safe singleton classes";
    homepage = "https://github.com/timofurrer/pysingleton";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
