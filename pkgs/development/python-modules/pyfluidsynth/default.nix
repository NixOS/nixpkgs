{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  numpy,
  fluidsynth,
  stdenv,
}:

buildPythonPackage rec {
  pname = "pyfluidsynth";
  version = "1.3.3";
  format = "pyproject";

  src = fetchPypi {
    pname = "pyFluidSynth";
    inherit version;
    hash = "sha256-1Q1LVQc+dYCyo8pHCZK2xRwnnbocVRLchRNVlfQtaIE=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "fluidsynth" ];

  postPatch = ''
    sed -Ezi fluidsynth.py -e \
      's|lib = .*\\\n[^\n]*|lib = "${lib.getLib fluidsynth}/lib/libfluidsynth${stdenv.hostPlatform.extensions.sharedLibrary}"|'
  '';

  meta = with lib; {
    description = "Python bindings for FluidSynth, a MIDI synthesizer that uses SoundFont instruments";
    homepage = "https://github.com/nwhitehead/pyfluidsynth";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ figsoda ];
  };
}
