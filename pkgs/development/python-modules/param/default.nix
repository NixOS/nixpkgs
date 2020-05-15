{ lib
, buildPythonPackage
, fetchPypi
, flake8
, nose
}:

buildPythonPackage rec {
  pname = "param";
  version = "1.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10crjlsn5vx03xwlnhga9faqq2rlw0qwabi45vnvhmz22qbd8w43";
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
