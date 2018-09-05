{ stdenv, buildPythonPackage, isPy3k, fetchPypi }:

buildPythonPackage rec {
  pname = "pymetar";
  version = "1.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n4k5aic4sgp43ki6j3zdw9b21r3biqqws8ah57b77n44b8wzrap";
  };

  meta = with stdenv.lib; {
    description = "A command-line tool to show the weather report by a given station ID";
    homepage = http://www.schwarzvogel.de/software/pymetar.html;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ erosennin ];
  };
}
