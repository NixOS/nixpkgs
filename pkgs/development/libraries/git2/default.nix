{stdenv, fetchurl, cmake, zlib, python}:

stdenv.mkDerivation rec {
  version = "0.18.0";
  name = "libgit2-${version}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/libgit2/libgit2/tarball/v${version}";
    md5 = "50409ddb0c34713677b33ef617e92c94";
  };

  nativeBuildInputs = [ cmake python ];
  buildInputs = [ zlib ];

  meta = {
    description = "the Git linkable library";
    homepage = http://libgit2.github.com/;
    license = with stdenv.lib.licenses; gpl2;
    platforms = with stdenv.lib.platforms; all;
  };
}
