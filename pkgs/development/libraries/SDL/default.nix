{stdenv, fetchurl, x11, openglSupport ? false, mesa ? null}:

assert openglSupport -> mesa != null;

stdenv.mkDerivation {
  name = "SDL-1.2.9";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/SDL-1.2.9.tar.gz;
    md5 = "80919ef556425ff82a8555ff40a579a0";
  };
  buildInputs = [
    x11
    (if openglSupport then mesa else null)
  ];
  patches = [./no-cxx.patch];
  NIX_CFLAGS_COMPILE = "-DBITS_PER_LONG=32"; /* !!! hack around kernel header bug */
  inherit openglSupport;
}
