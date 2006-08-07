{stdenv, fetchurl, x11, imake, gccmakedep, libXmu, libXpm, libXp, bison, flex}:

stdenv.mkDerivation {
  name = "Xaw3d-1.5E";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/Xaw3d-1.5E.tar.gz;
    md5 = "29ecfdcd6bcf47f62ecfd672d31269a1";
  };
  patches = [./config.patch ./laylex.patch];
  buildInputs = [x11 imake gccmakedep libXmu libXpm libXp bison flex];
  propagatedBuildInputs = [x11 libXmu];
}
