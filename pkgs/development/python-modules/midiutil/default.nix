{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "midiutil";
  version = "1.2.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "MIDIUtil";
    inherit version;
    sha256 = "02m9sqv36zrzgz5zg2w9qmz8snzlm27yg3ways2hgipgs4xriykr";
  };

  meta = {
    homepage = "https://github.com/MarkCWirt/MIDIUtil";
    description = "Pure python library for creating multi-track MIDI files";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
