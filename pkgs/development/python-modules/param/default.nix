{ lib
, buildPythonPackage
, fetchPypi
, flake8
, nose
}:

buildPythonPackage rec {
  pname = "param";
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dbnviszdq3d2k3dfwpimb0adf27yzwm4iyv42rk8xvd8c6p9gdi";
  };

  checkInputs = [ flake8 nose ];

  # tests not included with pypi release
  doCheck = false;

  meta = with lib; {
    description = "Declarative Python programming using Parameters";
    homepage = https://github.com/pyviz/param;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
