{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  cython_0,
  alsa-lib,
  CoreAudio,
  CoreMIDI,
  CoreServices,
}:

buildPythonPackage rec {
  pname = "rtmidi-python";
  version = "0.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wpcaxfpbmsjc78g8841kpixr0a3v6zn0ak058s3mm25kcysp4m0";
  };

  postPatch = ''
    rm rtmidi_python.cpp
  '';

  nativeBuildInputs = [ cython_0 ];
  buildInputs =
    lib.optionals stdenv.isLinux [ alsa-lib ]
    ++ lib.optionals stdenv.isDarwin [
      CoreAudio
      CoreMIDI
      CoreServices
    ];

  setupPyBuildFlags = [ "--from-cython" ];

  # package has no tests
  doCheck = false;

  pythonImportsCheck = [ "rtmidi_python" ];

  meta = with lib; {
    description = "Python wrapper for RtMidi";
    homepage = "https://github.com/superquadratic/rtmidi-python";
    license = licenses.mit;
    maintainers = [ ];
  };
}
