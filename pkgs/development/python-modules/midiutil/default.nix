{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "midiutil";
  version = "1.2.1";

  src = fetchPypi {
    pname = "MIDIUtil";
    inherit version;
    hash = "sha256-efqYO9HvxgeF9oqP54+o9FuNfsWJi/fLfz9/MzbWqQo=";
  };

  meta = with lib; {
    homepage = "https://github.com/MarkCWirt/MIDIUtil";
    description = "Pure python library for creating multi-track MIDI files";
    license = licenses.mit;
    maintainers = [ ];
  };
}
