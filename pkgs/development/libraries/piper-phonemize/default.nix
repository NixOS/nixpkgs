{ lib
, stdenv
, fetchFromGitHub

# build
, cmake
, pkg-config

# runtime
, espeak-ng
, onnxruntime
}:

let
  espeak-ng' = espeak-ng.overrideAttrs (oldAttrs: {
    version = "1.52-dev";
    src = fetchFromGitHub {
      owner = "rhasspy";
      repo = "espeak-ng";
      rev = "61504f6b76bf9ebbb39b07d21cff2a02b87c99ff";
      hash = "sha256-RBHL11L5uazAFsPFwul2QIyJREXk9Uz8HTZx9JqmyIQ=";
    };

    patches = [
      ./espeak-mbrola.patch
    ];
  });
in
stdenv.mkDerivation rec {
  pname = "piper-phonemize";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "piper-phonemize";
    rev = "refs/tags/v${version}";
    hash = "sha256-cMer7CSLOXv3jc9huVA3Oy5cjXjOX9XuEXpIWau1BNQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    espeak-ng'
    onnxruntime
  ];

  passthru = {
    espeak-ng = espeak-ng';
  };

  meta = with lib; {
    description = "C++ library for converting text to phonemes for Piper";
    homepage = "https://github.com/rhasspy/piper-phonemize";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
