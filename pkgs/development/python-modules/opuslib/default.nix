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
    repo = pname;
    rev = "92109c528f9f6c550df5e5325ca0fcd4f86b0909";
    hash = "sha256-NxmC/4TTIEDVzrfMPN4PcT1JY4QCw8IBMy80XiM/o00=";
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
