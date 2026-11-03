{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  six,
}:

buildPythonPackage rec {
  pname = "iniparse";
  version = "0.5.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T0/QCdSeQpCnIem8VxZxnpp2fJx/3D1+vEA+8zedYSk=";
  };

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  propagatedBuildInputs = [ six ];

  # Does not install tests
  doCheck = false;

  meta = {
    description = "Accessing and Modifying INI files";
    homepage = "https://github.com/candlepin/python-iniparse";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
