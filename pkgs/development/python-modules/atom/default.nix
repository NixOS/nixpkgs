{ lib, buildPythonPackage, fetchPypi, future, cppy }:

buildPythonPackage rec {
  pname = "atom";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "99b4c94b833aafffc0b34ab8f98b697f575be3230bff38ebf863d065403333e0";
  };

  buildInputs = [ cppy ];
  requiredPythonModules = [ future ];

  # Tests not released to pypi
  doCheck = true;

  meta = with lib; {
    description = "Memory efficient Python objects";
    maintainers = [ maintainers.bhipple ];
    homepage = "https://github.com/nucleic/atom";
    license = licenses.bsd3;
  };
}
