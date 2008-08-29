{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libmowgli-0.7.0";
  
  src = fetchurl {
    url = http://distfiles.atheme.org/libmowgli-0.7.0.tbz2;
    sha256 = "1d6318zfr4khlq8j290wxn026gnwdd6p81klkh6h0fkdawpvplzx";
  };
  
  meta = {
    description = "A development framework for C providing high performance and highly flexible algorithms";
    homepage = http://www.atheme.org/projects/mowgli.shtml;
  };
}
