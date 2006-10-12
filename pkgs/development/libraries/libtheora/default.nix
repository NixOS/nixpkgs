{stdenv, fetchurl, libogg, libvorbis}:

stdenv.mkDerivation {
  name = "libtheora-1.0alpha7";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libtheora-1.0alpha7.tar.bz2;
    md5 = "1bc851e39e4b16977131d5e5f769f48b";
  };
  propagatedBuildInputs = [libogg libvorbis];
}
