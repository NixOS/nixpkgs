{ lib, buildPythonPackage, fetchPypi, future, cppy }:

buildPythonPackage rec {
  pname = "atom";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce0c600e4b26b7553c926b3b8253df7ae19bbf2678bdc2d46eb29b5f9149f172";
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
