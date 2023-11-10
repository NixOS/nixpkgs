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
      rev = "0f65aa301e0d6bae5e172cc74197d32a6182200f";
      hash = "sha256-2V0D3QO+v9OqffpNmwJQd3NIBd/IFeLkjaJ3Y0HHw7E=";
    };

    patches = [
      ./espeak-mbrola.patch
    ];
  });
in
stdenv.mkDerivation rec {
  pname = "piper-phonemize";
  version = "2023.11.6-1";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "piper-phonemize";
    rev = "refs/tags/${version}";
    hash = "sha256-IRvuA03Z6r8Re/ocq2G/r28uwI9RU3xmmNI7S2G40rc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DONNXRUNTIME_DIR=${onnxruntime.dev}"
    "-DESPEAK_NG_DIR=${espeak-ng'}"
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
