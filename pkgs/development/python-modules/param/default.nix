{ lib
, buildPythonPackage
, fetchPypi
, flake8
, nose
}:

buildPythonPackage rec {
  pname = "param";
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a284c1b42aff6367e8eea2f649d4f3f70a9f16c6f17d8ad672a31ff36089f995";
  };

  checkInputs = [ flake8 nose ];

  # tests not included with pypi release
  doCheck = false;

  meta = with lib; {
    description = "Declarative Python programming using Parameters";
    homepage = "https://github.com/pyviz/param";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
