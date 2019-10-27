{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyx";
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05d1b7fc813379d2c12fcb5bd0195cab522b5aabafac88f72913f1d47becd912";
  };

  disabled = !isPy3k;

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python package for the generation of PostScript, PDF, and SVG files";
    homepage = http://pyx.sourceforge.net/;
    license = with licenses; [ gpl2 ];
  };

}
