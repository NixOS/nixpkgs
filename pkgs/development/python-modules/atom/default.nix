{ lib, buildPythonPackage, fetchPypi, future }:

buildPythonPackage rec {
  pname = "atom";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce96fb50326a3bfa084463dbde1cf2e02c92735e5bc324d836355c25af87e0ae";
  };

  propagatedBuildInputs = [ future ];

  # Tests not released to pypi
  doCheck = true;

  meta = with lib; {
    description = "Memory efficient Python objects";
    maintainers = [ maintainers.bhipple ];
    homepage = https://github.com/nucleic/atom;
    license = licenses.bsd3;
  };
}
