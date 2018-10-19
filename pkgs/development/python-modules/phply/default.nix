{ buildPythonPackage
, fetchPypi
, lib
, ply
, nose
}:

buildPythonPackage rec {
  pname = "phply";
  version = "1.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gwz4j0pp479bwg6iwk7kcdbr1s4x9fikqri0b4ddn7vi198fibx";
  };

  propagatedBuildInputs = [
    ply
  ];

  checkInputs = [
    nose
  ];

  meta = with lib; {
    description = "Lexer and parser for PHP source implemented using PLY";
    homepage = https://github.com/viraptor/phply;
    license = licenses.gpl2;
    maintainers = with maintainers; [ jtojnar ];
  };
}
