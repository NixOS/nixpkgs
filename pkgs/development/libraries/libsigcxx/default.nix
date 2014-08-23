{ stdenv, fetchurl, pkgconfig, gnum4 }:

stdenv.mkDerivation rec {
  name = "libsigc++-2.3.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libsigc++/2.3/${name}.tar.xz";
    sha256 = "14q3sq6d43f6wfcmwhw4v1aal4ba0h5x9v6wkxy2dnqznd95il37";
  };

  buildInputs = [ pkgconfig gnum4 ];

  doCheck = true;

  meta = {
    homepage = http://libsigc.sourceforge.net/;
    description = "A typesafe callback system for standard C++";
  };
}
