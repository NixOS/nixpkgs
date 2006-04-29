{stdenv, fetchurl, x11, libXp, libXau}:

stdenv.mkDerivation {
  name = "lesstif-0.94.4";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/lesstif-0.94.4.tar.bz2;
    md5 = "3096ca456c0bc299d895974d307c82d8";
  };
  buildInputs = [x11];
  propagatedBuildInputs = [libXp libXau];
}
