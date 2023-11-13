{ lib, stdenv, fetchFromGitHub
, automake, autoconf, readline
, libX11, bluez, SDL2
}:

stdenv.mkDerivation rec {
  pname = "X11basic";
  version = "1.27";

  src = fetchFromGitHub {
    owner = "kollokollo";
    repo = pname;
    rev = version;
    sha256 = "1hpxzdqnjl1fiwgs2vrjg4kxm29c7pqwk3g1m4p5pm4x33a3d1q2";
  };

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [
    readline libX11 SDL2 bluez
  ];

  preConfigure = "cd src;autoconf";

  configureFlags = [
    "--with-bluetooth"
    "--with-usb"
    "--with-readline"
    "--with-sdl"
    "--with-x"
    "--enable-cryptography"
  ];

  preInstall = ''
    touch x11basic.{eps,svg}
    mkdir -p $out/{bin,lib}
    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
    cp -r ../examples $out/share/.
  '';

  meta = with lib; {
    homepage = "https://x11-basic.sourceforge.net/";
    description = "A Basic interpreter and compiler with graphics capabilities";
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.unix;
  };

}
