{ lib, buildPythonPackage, fetchPypi, future, cppy }:

buildPythonPackage rec {
  pname = "atom";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "df65a654744ccdc4843ce09c38612fd8f702c84be501b1d955c3ac0b9ad28dc5";
  };

  buildInputs = [ cppy ];
  propagatedBuildInputs = [ future ];

  # Tests not released to pypi
  doCheck = true;

  meta = with lib; {
    description = "Memory efficient Python objects";
    maintainers = [ maintainers.bhipple ];
    homepage = "https://github.com/nucleic/atom";
    license = licenses.bsd3;
  };
}
