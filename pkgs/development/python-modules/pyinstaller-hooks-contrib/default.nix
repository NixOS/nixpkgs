{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyinstaller-hooks-contrib";
  version = "2023.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dghLWYjjlXqd8WnSqTXWVQATaWfnEN3r9XJj8akJzYA=";
  };

  propagatedBuildInputs = [ ];

#  pythonImportsCheck = [ "macholib" ];

  meta = with lib; {
    description = "Community maintained hooks for PyInstaller";
    homepage = "https://github.com/pyinstaller/pyinstaller-hooks-contrib";
    license = licenses.gpl2;
    maintainers = with maintainers; [ provenzano ];
  };
}
