{ stdenv, fetchurl, pkgconfig, pixman, celt, alsaLib, openssl
, libXrandr, libXfixes, libXext, libXrender, libXinerama, libjpeg, zlib
, spice_protocol, python, pyparsing, glib, cyrus_sasl, lz4 }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "spice-0.12.8";

  src = fetchurl {
    url = "http://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "0za03i77j8i3g5l2np2j7vy8cqsdbkm9wbv4hjnaqq9xhz2sa0gr";
  };

  buildInputs = [ pixman celt alsaLib openssl libjpeg zlib
                  libXrandr libXfixes libXrender libXext libXinerama
                  python pyparsing glib cyrus_sasl lz4 ];

  nativeBuildInputs = [ pkgconfig spice_protocol ];

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  configureFlags = [
    "--with-sasl"
    "--disable-smartcard"
    "--enable-client"
    "--enable-lz4"
  ];

  postInstall = ''
    ln -s spice-server $out/include/spice
  '';

  meta = {
    description = "Complete open source solution for interaction with virtualized desktop devices";
    longDescription = ''
      The Spice project aims to provide a complete open source solution for interaction
      with virtualized desktop devices.The Spice project deals with both the virtualized
      devices and the front-end. Interaction between front-end and back-end is done using
      VD-Interfaces. The VD-Interfaces (VDI) enable both ends of the solution to be easily
      utilized by a third-party component.
    '';
    homepage = http://www.spice-space.org/;
    license = licenses.lgpl21;

    maintainers = [ maintainers.bluescreen303 ];
    platforms = platforms.linux;
  };
}
