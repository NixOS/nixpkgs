{ buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
    # https://github.com/orion-labs/opuslib/pull/22
    (fetchpatch {
      name = "fix-variadic-functions-on-aarch64-darwin.patch";
      url = "https://github.com/orion-labs/opuslib/commit/8aee916e4da4b3183d49cff5a986dc2408076d8d.patch";
      hash = "sha256-oa1HCFHNS3ejzSf0jxv9NueUKOZgdCtpv+xTrjYW5os=";
    })
    (substituteAll {
      src = ./opuslib-paths.patch;
      opusLibPath = "${libopus}/lib/libopus${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeCheckInputs = [ nose ];

  meta = with lib; {
    description = "Python bindings to the libopus, IETF low-delay audio codec";
    homepage = "https://github.com/orion-labs/opuslib";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ thelegy ];
  };
}
