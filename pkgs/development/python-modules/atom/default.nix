{ lib, buildPythonPackage, fetchPypi, future, cppy }:

buildPythonPackage rec {
  pname = "atom";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LnLyNaljNocqAKr85VhIxZqU3KIPAPWnQpazcdoNrXE=";
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
