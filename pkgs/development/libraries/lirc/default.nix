{ stdenv, fetchurl, alsaLib, bash, help2man }:

stdenv.mkDerivation rec {
  name = "lirc-0.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/lirc/${name}.tar.bz2";
    sha256 = "0vakq9x10hyj9k7iv35sm5f4dhxvk0miwxvv6kn0bhwkr2mnapj6";
  };

  preBuild = "patchShebangs .";

  buildInputs = [ alsaLib help2man ];

  configureFlags = [
    "--with-driver=devinput"
    "--sysconfdir=$(out)/etc"
    "--enable-sandboxed"
  ];

  makeFlags = [ "m4dir=$(out)/m4" ];

  meta = with stdenv.lib; {
    description = "Allows to receive and send infrared signals";
    homepage = http://www.lirc.org/;
    license = licenses.gpl2;
    platforms = platforms.linux
    maintainers = with maintainers; [ pSub ];
  };
}
