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
    hash = "sha256-V3bnpLoLqyZwnaYE9OZIxYFDhf7zQBByPbPaDUGw28w=";
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
