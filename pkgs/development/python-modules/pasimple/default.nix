{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pulseaudio
}:

buildPythonPackage rec {
  pname = "pasimple";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "henrikschnor";
    repo = "pasimple";
    rev = "v${version}";
    hash = "sha256-Z271FdBCqPFcQzVqGidL74nO85rO9clNvP4czAHmdEw=";
  };

  postPatch = ''
    substituteInPlace pasimple/pa_simple.py --replace \
      "_libpulse_simple = ctypes.CDLL('libpulse-simple.so.0')" \
      "_libpulse_simple = ctypes.CDLL('${lib.getLib pulseaudio}/lib/libpulse-simple.so.0')"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "pasimple"
    "pasimple.pa_simple"
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "A python wrapper for the \"PulseAudio simple API\". Supports playing and recording audio via PulseAudio and PipeWire";
    homepage = "https://github.com/henrikschnor/pasimple";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
