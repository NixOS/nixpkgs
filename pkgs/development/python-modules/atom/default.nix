{ lib, buildPythonPackage, fetchPypi, future }:

buildPythonPackage rec {
  pname = "atom";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0awzja4k3f32y01gd068yyxvh35km62m4wka0vbg1yyy37ahgjmv";
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
