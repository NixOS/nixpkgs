{stdenv, fetchurl, x11, libXp, libXau}:

stdenv.mkDerivation {
  name = "lesstif-0.95";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/lesstif/lesstif-0.95.0.tar.bz2;
    md5 = "ab895165c149d7f95843c7584b1c7ad4";
  };
  buildInputs = [x11];
  propagatedBuildInputs = [libXp libXau];
  patches = [./c-linkage.patch];
}
