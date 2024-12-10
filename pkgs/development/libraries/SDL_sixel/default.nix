{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libsixel,
}:

stdenv.mkDerivation {
  pname = "SDL_sixel";
  version = "1.2-nightly";

  src = fetchFromGitHub {
    owner = "saitoha";
    repo = "SDL1.2-SIXEL";
    rev = "ab3fccac6e34260a617be511bd8c2b2beae41952";
    sha256 = "0gm2vngdac17lzw9azkhzazmfq3byjddms14gqjk18vnynfqp5wp";
  };

  configureFlags = [ "--enable-video-sixel" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsixel ];

  meta = with lib; {
    description = "A cross-platform multimedia library, that supports sixel graphics on consoles";
    mainProgram = "sdl-config";
    homepage = "https://github.com/saitoha/SDL1.2-SIXEL";
    maintainers = with maintainers; [ vrthra ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
