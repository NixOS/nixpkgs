{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
}:

let
  name = "liblc3";
  version = "1.0.1";
in
stdenv.mkDerivation {
  pname = name;
  version = version;

  src = fetchFromGitHub {
    owner = "google";
    repo = "liblc3";
    rev = "v${version}";
    sha256 = "sha256-W0pCfFmM+6N6+HdGdQ/GBNHjBspkwtlxZC2m2noKGx0=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = with lib; {
    description = "LC3 (Low Complexity Communication Codec) is an efficient low latency audio codec";
    homepage = "https://github.com/google/liblc3";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jansol ];
  };
}

