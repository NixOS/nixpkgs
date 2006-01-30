{ stdenv, fetchurl, pkgconfig}:

stdenv.mkDerivation {
  name = "libsigc++-2.0.16";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libsigc++-2.0.16.tar.gz;
    md5 = "49b8c091b1be84d9f9801c4c81cd98b8";
  };

  buildInputs = [pkgconfig];
}

