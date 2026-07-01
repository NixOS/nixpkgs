{
  buildPythonPackage,
  fetchurl,
  cffi,
  lib,
  pydub,
  setuptools,
  tinytag,
}:

buildPythonPackage rec {
  pname = "just-playback";
  version = "0.1.8";
  pyproject = true;

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/a4/2d/19ffa29233196f146dd98ffcfd3751b81e43efdd6274f5fac0bdd245038d/just_playback-0.1.8.tar.gz";
    sha256 = "sha256-5ZdHSfEPque7drPx43eaE2knWrF52HWdrifp8ptBA1A=";
  };

  nativeBuildInputs = [ setuptools cffi ];

  propagatedBuildInputs = [
    cffi
    tinytag
    pydub
  ];

  meta = {
    description = "A small library for playing audio files in python, with essential playback functionality.";
    homepage = "https://github.com/cheofusi/just_playback";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}