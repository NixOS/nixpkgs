{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  six,
}:

buildPythonPackage rec {
  pname = "iniparse";
  version = "0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ky5SOdUm56y1BAF7twe+ZwGaxCimkyNo5oUWkQk6qEI=";
  };

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  propagatedBuildInputs = [ six ];

  # Does not install tests
  doCheck = false;

  meta = with lib; {
    description = "Accessing and Modifying INI files";
    homepage = "https://github.com/candlepin/python-iniparse";
    license = licenses.mit;
    maintainers = with maintainers; [ danbst ];
  };
}
