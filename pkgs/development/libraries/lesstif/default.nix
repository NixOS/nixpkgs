{stdenv, fetchurl, x11, libXp, libXau}:

stdenv.mkDerivation {
  name = "lesstif-0.95";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/lesstif-0.95.0.tar.bz2;
    md5 = "ab895165c149d7f95843c7584b1c7ad4";
  };
  buildInputs = [x11];
  propagatedBuildInputs = [libXp libXau];
}
