{stdenv, fetchurl, kernelHeaders, patch}:

assert patch != null;

stdenv.mkDerivation {
  name = "glibc-2.3.2";
  builder = ./builder.sh;

  src = fetchurl {
    url = ftp://ftp.nl.net/pub/gnu/glibc/glibc-2.3.2.tar.bz2;
    md5 = "ede969aad568f48083e413384f20753c";
  };
  linuxthreadsSrc = fetchurl {
    url = ftp://ftp.nl.net/pub/gnu/glibc/glibc-linuxthreads-2.3.2.tar.bz2;
    md5 = "894b8969cfbdf787c73e139782167607";
  };

  # This is a patch to make glibc compile under GCC 3.3.  Presumably
  # later releases of glibc won't need this.
  patches = [./glibc-2.3.2-sscanf-1.patch];

  buildInputs = [patch];
  inherit kernelHeaders;
}
