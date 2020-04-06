{ lib
, buildPythonPackage
, fetchPypi
, flake8
, nose
}:

buildPythonPackage rec {
  pname = "param";
  version = "1.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a2dcb07c6a4ff48bade69bb5d30d84a96911a7e9dcb76b6de975453f933332f8";
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
