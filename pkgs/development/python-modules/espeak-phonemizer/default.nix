{ lib
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, espeak-ng
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "espeak-phonemizer";
  version = "1.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "espeak-phonemizer";
    rev = "refs/tags/v${version}";
    hash = "sha256-FiajWpxSDRxTiCj8xGHea4e0voqOvaX6oQYB72FkVbw=";
  };

  patches = [
    (substituteAll {
      src = ./cdll.patch;
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
