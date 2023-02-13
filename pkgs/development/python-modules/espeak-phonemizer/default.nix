{ lib
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, glibc
, espeak-ng
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "espeak-phonemizer";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "espeak-phonemizer";
    rev = "refs/tags/v${version}";
    hash = "sha256-qnJtS5iIARdg+umolzLHT3/nLon9syjxfTnMWHOmYPU=";
  };

  patches = [
    (substituteAll {
      src = ./cdll.patch;
      libc = "${lib.getLib glibc}/lib/libc.so.6";
      libespeak_ng = "${lib.getLib espeak-ng}/lib/libespeak-ng.so";
    })
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/rhasspy/espeak-phonemizer/releases/tag/v${version}";
    description = "Uses ctypes and libespeak-ng to transform test into IPA phonemes";
    homepage = "https://github.com/rhasspy/espeak-phonemizer";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.linux;
  };
}
