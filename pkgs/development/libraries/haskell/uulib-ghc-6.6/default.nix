{stdenv, fetchurl, autoconf, ghc}:

stdenv.mkDerivation
{
  name = "uulib-0.9.2-ghc-6.6";
  src = fetchurl { url = http://www.cs.uu.nl/~ariem/uulib-2006-10-30-src.tar.gz;
                   md5 = "d26059447d45fa91f54eca38680be7b7";
                 };
  builder = ./builder.sh;
  buildInputs = [ autoconf ghc ];
}
