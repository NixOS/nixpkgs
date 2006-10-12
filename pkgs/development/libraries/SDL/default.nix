{ stdenv, fetchurl, x11, libXrandr, openglSupport ? false, mesa ? null
, alsaSupport ? true, alsaLib ? null
}:

assert openglSupport -> mesa != null;
assert alsaSupport -> alsaLib != null;

stdenv.mkDerivation {
  name = "SDL-1.2.11";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/SDL-1.2.11.tar.gz;
    md5 = "418b42956b7cd103bfab1b9077ccc149";
  };
  propagatedBuildInputs = [x11 libXrandr];
  buildInputs = 
    (if openglSupport then [mesa] else []) ++
    (if alsaSupport then [alsaLib] else []);
  configureFlags = "
    --disable-x11-shared --disable-alsa-shared --enable-rpath
    ${if alsaSupport then "--with-alsa-prefix=${alsaLib}/lib" else ""}
  ";
#  patches = [./no-cxx.patch];
#  NIX_CFLAGS_COMPILE = "-DBITS_PER_LONG=32"; /* !!! hack around kernel header bug */
  inherit openglSupport;
}
