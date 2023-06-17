{ lib, stdenv, fetchFromGitHub, cmake, SDL2}:

#TODO: tests

stdenv.mkDerivation rec {
  pname = "faudio";
  version = "23.05";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FAudio";
    rev = version;
    sha256 = "sha256-uZSKbLQ36Kw6useAKyDoxLKD1xtKbigq/ejWErxvkcE=";
  };

  nativeBuildInputs = [cmake];

  buildInputs = [ SDL2 ];

  meta = with lib; {
    description = "XAudio reimplementation focusing to develop a fully accurate DirectX audio library";
    homepage = "https://github.com/FNA-XNA/FAudio";
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = [ maintainers.marius851000 ];
  };
}
