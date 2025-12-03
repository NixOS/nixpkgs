{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  fluidsynth,
  stdenv,
}:

buildPythonPackage rec {
  pname = "pyfluidsynth";
  version = "1.3.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ynQcJity5IljFJxzv4roDkXITCPJvfgDomujJMuy1bI=";
  };

  postPatch = ''
    substituteInPlace fluidsynth.py \
      --replace-fail \
        "find_library(lib_name)" \
        '"${lib.getLib fluidsynth}/lib/libfluidsynth${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "fluidsynth" ];

  meta = with lib; {
    description = "Python bindings for FluidSynth, a MIDI synthesizer that uses SoundFont instruments";
    homepage = "https://github.com/nwhitehead/pyfluidsynth";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
