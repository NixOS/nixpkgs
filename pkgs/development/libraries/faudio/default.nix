{ lib, stdenv, fetchFromGitHub, cmake, SDL2}:

#TODO: tests

stdenv.mkDerivation rec {
  pname = "faudio";
  version = "23.11";

  src = fetchFromGitHub {
    owner = "FNA-XNA";
    repo = "FAudio";
    rev = version;
    sha256 = "sha256-iK0cjhq16DU/77p0cM3SMk+gE1PQV0zd96a3kxwXNLk=";
  };

  nativeBuildInputs = [cmake];

  buildInputs = [ SDL2 ];

  meta = with lib; {
    description = "XAudio reimplementation focusing to develop a fully accurate DirectX audio library";
    homepage = "https://github.com/FNA-XNA/FAudio";
    changelog = "https://github.com/FNA-XNA/FAudio/releases/tag/${version}";
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = [ maintainers.marius851000 ];
  };
}
