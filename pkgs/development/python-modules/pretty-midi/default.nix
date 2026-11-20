{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  numpy,
  mido,
  six,
  importlib-resources,
}:

buildPythonPackage (finalAttrs: {
  pname = "pretty-midi";
  version = "0.2.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "craffel";
    repo = "pretty-midi";
    tag = finalAttrs.version;
    hash = "sha256-hkhthjTLWVVMHEhWi63rh6hAOZZ6fVMwbBhYvC9xXc8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    mido
    six
    importlib-resources
  ];

  meta = {
    description = "Functions and classes for handling MIDI data conveniently";
    homepage = "https://github.com/craffel/pretty-midi/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ astro ];
  };
})
