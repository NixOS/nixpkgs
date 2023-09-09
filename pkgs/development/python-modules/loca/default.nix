{ lib, buildPythonPackage, pythonOlder, fetchFromSourcehut, flit-core }:

buildPythonPackage rec {
  pname = "loca";
  version = "2.0.1";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = pname;
    rev = version;
    sha256 = "1l6jimw3wd81nz1jrzsfw1zzsdm0jm998xlddcqaq0h38sx69w8g";
  };

  nativeBuildInputs = [
    flit-core
  ];

  doCheck = false; # all checks are static analyses
  pythonImportsCheck = [ "loca" ];

  meta = with lib; {
    description = "Local locations";
    homepage = "https://pypi.org/project/loca";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.McSinyx ];
  };
}
