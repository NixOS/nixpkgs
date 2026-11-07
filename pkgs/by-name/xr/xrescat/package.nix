{
  lib,
  stdenv,
  fetchFromGitHub,
  gnumake,
  gcc,
  gdb,
  xorg,
  SDL2,
}:

stdenv.mkDerivation rec {
  pname = "xrescat";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "xrescat";
    rev = "e8e261441682244112b2020e2ad102768e6ba3fd";
    sha256 = "0mMcoNNkaFO6O0F8HjIA8Q8MtfSHLeXY9cGkVd83Vls=";
  };

  buildInputs = [
    gnumake
    gcc
    gdb
    xorg.libX11.dev
    SDL2.dev
  ];

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out
    make install DESTDIR=$out
    cp -r $out/usr/* $out/
  '';

  meta = {
    description = "Cat Xresources";
    homepage = "https://github.com/regolith-linux/xrescat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sandptel ];
    mainProgram = "xrescat";
    platforms = lib.platforms.linux;
  };
}
