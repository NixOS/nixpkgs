{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyx";
  version = "0.15";
  disabled = !isPy3k;

  src = fetchPypi {
    pname = "PyX";
    inherit version;
    sha256 = "0xs9brmk9fvfmnsvi0haf13xwz994kv9afznzfpg9dkzbq6b1hqg";
  };

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python package for the generation of PostScript, PDF, and SVG files";
    homepage = "http://pyx.sourceforge.net/";
    license = with licenses; [ gpl2 ];
  };
}
