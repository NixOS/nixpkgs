{ stdenv, fetchFromGitHub
, automake, autoconf, readline
, libX11, bluez, SDL2
}:

stdenv.mkDerivation rec {
  pname = "X11basic";
  version = "1.26";

  src = fetchFromGitHub {
    owner = "kollokollo";
    repo = pname;
    rev = version;
    sha256 = "0rwj9cf496xailply0rgw695bzdladh2dhy7vdqac1pwbkl53nvd";
  };

  buildInputs = [
    autoconf automake readline libX11 SDL2 bluez
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

  meta = with stdenv.lib; {
    homepage = http://x11-basic.sourceforge.net/;
    description = "A Basic interpreter and compiler with graphics capabilities.";
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.unix;
  };

}
