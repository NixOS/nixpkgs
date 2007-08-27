{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libsigsegv-2.1";
  src = fetchurl {
    url = mirror://gnu/libsigsegv/libsigsegv-2.1.tar.gz;
    md5 = "6d75ca3fede5fbfd72a78bc918d9e174";
  };
}
