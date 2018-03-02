{ stdenv, buildPythonPackage, isPy3k, fetchPypi }:

buildPythonPackage rec {
  pname = "pymetar";
  version = "0.21";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sh3nm5ilnsgpnzbb2wv4xndnizjayw859qp72798jadqpcph69k";
  };

  meta = with stdenv.lib; {
    description = "A command-line tool to show the weather report by a given station ID";
    homepage = http://www.schwarzvogel.de/software/pymetar.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ erosennin ];
  };
}
