{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "distro";
  version = "1.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AuER0dxqUKu47ta/McPkjtiwgw0eoqG3jGF2XCUT/dg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Tests are very targeted at individual Linux distributions
  doCheck = false;

  pythonImportsCheck = [
    "distro"
  ];

  meta = with lib; {
    description = "Library to gather information about the OS it runs on";
    homepage = "https://github.com/nir0s/distro";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
