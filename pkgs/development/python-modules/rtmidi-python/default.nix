{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  cython_0,
  alsa-lib,
}:

buildPythonPackage rec {
  pname = "rtmidi-python";
  version = "0.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oJKrPZtF1Do0KmAqYL/ZQ4Hc452BIPTQYVLXdV1X7PI=";
  };

  postPatch = ''
    rm rtmidi_python.cpp
  '';

  nativeBuildInputs = [ cython_0 ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  setupPyBuildFlags = [ "--from-cython" ];

  # package has no tests
  doCheck = false;

  pythonImportsCheck = [ "rtmidi_python" ];

  meta = {
    description = "Python wrapper for RtMidi";
    homepage = "https://github.com/superquadratic/rtmidi-python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
