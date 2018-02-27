{ stdenv, fetchurl, autoconf, automake, pkgconfig,
  libtool, SDL2, libpng }:

stdenv.mkDerivation rec {
  name = "libqrencode-${version}";
  version = "4.0.0";

  src = fetchurl {
    url = "https://fukuchi.org/works/qrencode/qrencode-${version}.tar.gz";
    sha1 = "644054a76c8b593acb66a8c8b7dcf1b987c3d0b2";
    sha256 = "10da4q5pym7pzxcv21w2kc2rxmq7sp1rg58zdklwfr0jjci1nqjv";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake libtool SDL2 libpng ];

  propagatedBuildInputs = [ SDL2 libpng ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://fukuchi.org/works/qrencode/;
    description = "A C library for encoding data in a QR Code symbol";

    longDescription = ''
      Libqrencode is a C library for encoding data in a QR Code symbol,
      a kind of 2D symbology that can be scanned by handy terminals
      such as a mobile phone with CCD.
    '';

    license = licenses.gpl2Plus;
    maintainers = [ maintainers.adolfogc ];
    platforms = platforms.unix;
  };
}
