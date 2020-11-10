{ stdenv, buildPythonPackage, fetchPypi, pkg-config, libsmf, glib, pytest }:

buildPythonPackage rec {
  pname = "pysmf";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10i7vvvdx6c3gl4afsgnpdanwgzzag087zs0fxvfipnqknazj806";
  };

  nativeBuildInputs = [ pkg-config pytest ];
  buildInputs = [ libsmf glib ];

  meta = with stdenv.lib; {
    homepage = "http://das.nasophon.de/pysmf/";
    description = "Python extension module for reading and writing Standard MIDI Files, based on libsmf.";
    license = licenses.bsd2;
    maintainers = [ maintainers.gnidorah ];
  };
}
