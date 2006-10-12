{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libdvdnav-20050211";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libdvdnav-20050211.tar.bz2;
    md5 = "e1b1d45c8fdaf6a2dce3078bd3d7047d";
  };
}
