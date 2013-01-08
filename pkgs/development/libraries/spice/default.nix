{ stdenv, fetchurl, pkgconfig, pixman, celt, alsaLib, openssl
, libXrandr, libXfixes, libXext, libXrender, libXinerama, libjpeg, zlib
, spice_protocol, python, pyparsing }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "spice-0.12.0";

  src = fetchurl {
    url = "http://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "15mp6nz467h4l5jg3vk51si6r5w7g329jvsy61f2gl3yabwcxmva";
  };

  buildInputs = [ pixman celt alsaLib openssl libjpeg zlib
                  libXrandr libXfixes libXrender libXext libXinerama
                  python pyparsing ];

  buildNativeInputs = [ pkgconfig spice_protocol ];

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  configureFlags = [
    "--with-sasl=no"
    "--disable-smartcard"
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
