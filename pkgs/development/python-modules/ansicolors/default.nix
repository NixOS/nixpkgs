{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ansicolors";
  version = "1.1.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "99f94f5e3348a0bcd43c82e5fc4414013ccc19d70bd939ad71e0133ce9c372e0";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = {
    homepage = "https://github.com/verigak/colors/";
    description = "ANSI colors for Python";
    license = lib.licenses.isc;
    maintainers = [ ];
  };
}
