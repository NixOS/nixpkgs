{ lib
, buildPythonPackage
, fetchPypi
, flake8
, nose
}:

buildPythonPackage rec {
  pname = "param";
  version = "1.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b9857df01495bd55ddafb214fd1ed017d20699ce42ec2a0fd190d99caa03099f";
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
