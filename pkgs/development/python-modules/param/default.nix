{ lib
, buildPythonPackage
, fetchPypi
, flake8
, nose
}:

buildPythonPackage rec {
  pname = "param";
  version = "1.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "49927979d4f6c994bcd8f6f7f2b34e3a0a7f0d62404dca6bcae5acde0192bb01";
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
