{ lib
, buildPythonPackage
, fetchFromGitHub

# compile time
, swig

# runtime
, alsa-lib
, pulseaudio

# tests
, python
}:

let
  pname = "pocketsphinx";
  version = "0.1.15";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "AzatAI";
    repo = "pocketsphinx-python";
    rev = "v${version}";
    #hash = "sha256:KJj4unrcqhvKREKFnMgbgrldy1FuKIWettr/serzGzc=";
    hash = "sha256-6Lf5Y2mF7Hvjn7Z98axgXDDx08zmS+Ze7I2iERKXIaI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    swig
  ];

  buildInputs = [
    alsa-lib.dev
    pulseaudio.dev
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover
    runHook postCheck
  '';

  pythonImportsCheck = [
    "pocketsphinx"
  ];

  meta = with lib; {
    description = "Python interface to CMU Sphinxbase and Pocketsphinx libraries";
    homepage = "https://github.com/AzatAI/pocketsphinx-python";
    license = licenses.bsd2;
    maintainers = teams.mycroft.members;
  };
}
