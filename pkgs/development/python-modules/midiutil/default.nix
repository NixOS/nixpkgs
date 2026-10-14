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
    hash = "sha256-efqYO9HvxgeF9oqP54+o9FuNfsWJi/fLfz9/MzbWqQo=";
  };

  meta = {
    homepage = "https://github.com/MarkCWirt/MIDIUtil";
    description = "Pure python library for creating multi-track MIDI files";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
