{ lib
, buildPythonPackage
, fetchPypi
, flake8
, nose
}:

buildPythonPackage rec {
  pname = "param";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f0f1133fbadcd2c5138e579b9934e29fd00f803af01d9bf6f9e6b80ecf1999b";
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
