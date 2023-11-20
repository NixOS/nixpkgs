{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, numpy
, fluidsynth
, stdenv
, fetchpatch
}:

buildPythonPackage rec {
  pname = "pyfluidsynth";
  version = "1.3.2";
  format = "pyproject";

  src = fetchPypi {
    pname = "pyFluidSynth";
    inherit version;
    hash = "sha256-+i5oOXV4UG6z4rQGuguOP0mHo7V7fJZZRwOnJKB1VfQ=";
  };

  patches = [
    # fixes error: Unknown integer parameter 'synth.sample-rate'
    # https://github.com/nwhitehead/pyfluidsynth/pull/44
    (fetchpatch {
      name = "add-fluid-synth-get-status-and-fix-some-typing-bugs.patch";
      url = "https://github.com/nwhitehead/pyfluidsynth/commit/1b31ca6ab00930dbb515c4cc00bb31a65578b7c0.patch";
      hash = "sha256-ZCqy7aIv5iAAJrWOD7e538xltj11gy5fakIXnAbUsu8=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
  ];

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
