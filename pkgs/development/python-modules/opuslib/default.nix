{ buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  libopus,
  nose,
  lib, stdenv,
  substituteAll,
}:

buildPythonPackage rec {
  pname = "opuslib";
  version = "3.0.3";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "orion-labs";
    repo = "opuslib";
    rev = "92109c528f9f6c550df5e5325ca0fcd4f86b0909";
    sha256 = "0kd37wimwd1g6c0w5hq2hiiljgbi1zg3rk5prval086khkzq469p";
  };

  patches = [
    (substituteAll {
      src = ./opuslib-paths.patch;
      opusLibPath = "${libopus}/lib/libopus${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  checkInputs = [ nose ];

  meta = with lib; {
    description = "Python bindings to the libopus, IETF low-delay audio codec";
    homepage = "https://github.com/orion-labs/opuslib";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ thelegy ];
  };
}
