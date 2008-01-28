args:
with args;
stdenv.mkDerivation rec {
  name = "redland-1.0.7";

  src = fetchurl {
    url = "sf://librdf/${name}.tar.gz";
    sha256 = "1z160hhrnlyy5c8vh2hjza6kdfmzml8mg9dk8yffifkhnxjq5r2z";
  };
  buildInputs = [ bdb openssl libxml2 pkgconfig perl];
  configureFlags="--without-static --with-threads --with-bdb=${bdb}";
  patchPhase="sed -e 1s@/usr@${perl}@ -i utils/touch-mtime.pl";
}
