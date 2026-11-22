{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  six,
}:

buildPythonPackage rec {
  pname = "iniparse";
  version = "0.5.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nK39ffpVGu1Y+R8zMyF1Ok199v92VlH9pa/+/6zjP+g=";
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
