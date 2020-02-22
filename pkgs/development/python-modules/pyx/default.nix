{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyx";
  version = "0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fc3b00c5e7fb6f4aefbf63b95f624297dde47700a82b8b5ad6ebb346b5e4977";
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
