{ lib, stdenv, fetchFromGitHub, cmake, SDL2}:

#TODO: tests

stdenv.mkDerivation rec {
  pname = "faudio";
  version = "23.01";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FAudio";
    rev = version;
    sha256 = "sha256-/XfwQUkhn82vAKa7ZyiPbD4c7XJhCIncxvWkj/m2P0M=";
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
