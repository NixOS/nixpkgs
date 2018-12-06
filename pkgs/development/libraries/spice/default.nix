{ stdenv, fetchurl, pkgconfig, pixman, celt, alsaLib
, openssl, libXrandr, libXfixes, libXext, libXrender, libXinerama
, libjpeg, zlib, spice-protocol, python, pyparsing, glib, cyrus_sasl
, libcacard, lz4 }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "spice-0.14.0";

  src = fetchurl {
    url = "https://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "0j5q7cp5p95jk8fp48gz76rz96lifimdsx1wnpmfal0nnnar9nrs";
  };

  buildInputs = [ pixman celt alsaLib openssl libjpeg zlib
                  libXrandr libXfixes libXrender libXext libXinerama
                  python pyparsing glib cyrus_sasl libcacard lz4 ];

  nativeBuildInputs = [ pkgconfig spice-protocol ];

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  configureFlags = [
    "--with-sasl"
    "--enable-smartcard"
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
    homepage = https://www.spice-space.org/;
    license = licenses.lgpl21;

    maintainers = [ maintainers.bluescreen303 ];
    platforms = platforms.linux;
  };
}
