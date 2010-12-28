{ stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "libedit-20100424-3.0";

  src = fetchurl {
    url = "http://www.thrysoee.dk/editline/${name}.tar.gz";
    sha256 = "11hxaq58gym7kqccjhxywjxdibffzg545z1aj997y1dn0rckhav0";
  };

  postInstall = ''
    sed -i s/-lncurses/-lncursesw/g $out/lib/pkgconfig/libedit.pc
  '';

  configureFlags = "--enable-widec";

  propagatedBuildInputs = [ ncurses ];

  meta = {
    homepage = "http://www.thrysoee.dk/editline/";
    description = "A port of the NetBSD Editline library (libedit)";
  };
}
