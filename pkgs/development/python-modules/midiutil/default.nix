{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "MIDIUtil";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02m9sqv36zrzgz5zg2w9qmz8snzlm27yg3ways2hgipgs4xriykr";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/MarkCWirt/MIDIUtil";
    description = "A pure python library for creating multi-track MIDI files";
    license = licenses.mit;
    maintainers = [ maintainers.gnidorah ];
  };
}
