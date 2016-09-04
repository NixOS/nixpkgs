{stdenv, fetchurl, xlibsWrapper, imake, gccmakedep, libXmu, libXpm, libXp, bison, flex}:

stdenv.mkDerivation {
  name = "Xaw3d-1.5E";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://freshmeat.net/redir/xaw3d/11835/url_tgz/Xaw3d-1.5E.tar.gz;
    md5 = "29ecfdcd6bcf47f62ecfd672d31269a1";
  };
  patches = [./config.patch ./laylex.patch];
  buildInputs = [imake gccmakedep libXpm libXp bison flex];
  propagatedBuildInputs = [xlibsWrapper libXmu];

  meta = {
    description = "3D widget set based on the Athena Widget set";
    platforms = stdenv.lib.platforms.linux;
  };
}
