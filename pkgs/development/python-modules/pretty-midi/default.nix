{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  numpy,
  mido,
  six,
  importlib-resources,
}:

buildPythonPackage rec {
  pname = "pretty-midi";
  version = "0.2.11.post0";
  pyproject = true;

  src = fetchPypi {
    pname = "pretty_midi";
    inherit version;
    hash = "sha256-yR5AybCHsFEfUDw++7qJK0HnBIyDHK/cy/a6llYyoL8=";
  };

  build-system = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    mido
    six
    importlib-resources
  ];

  meta = with lib; {
    description = "Functions and classes for handling MIDI data conveniently.";
    homepage = "https://github.com/craffel/pretty-midi/";
    license = licenses.mit;
    maintainers = with maintainers; [ astro ];
  };
}
