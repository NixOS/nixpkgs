{ stdenv, fetchurl, pkgconfig, pixman, celt, alsaLib, openssl
, libXrandr, libXfixes, libXext, libXrender, libXinerama, libjpeg, zlib
, spiceProtocol }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "spice-0.10.1";

  src = fetchurl {
    url = "http://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "105p5fh6hhhzvz0fh1x52lzi41rpvajf390xbbw3da4417lf5pqk";
  };

  buildInputs = [ pixman celt alsaLib openssl libjpeg zlib
                  libXrandr libXfixes libXrender libXext libXinerama
                ];

  buildNativeInputs = [ pkgconfig spiceProtocol ];

  # NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  configureFlags = [
    "--with-sasl=no"
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
    platforms = platforms.all;
  };
}
