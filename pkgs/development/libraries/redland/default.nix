args:
with args;
stdenv.mkDerivation {
  name = "redland-1.0.6";

  src = fetchurl {
    url = http://prdownloads.sourceforge.net/librdf/redland-1.0.6.tar.gz;
    sha256 = "16hm8s6wy43avy4xcsq74n2dyzwzsdq2h2l2jav0by7s6mkh5gxw";
  };
  buildInputs = [ bdb openssl libxml2 pkgconfig perl];
  configureFlags="--without-static --with-threads --with-bdb=${bdb}";
  patchPhase="sed -e 1s@/usr@${perl}@ -i utils/touch-mtime.pl";
}
