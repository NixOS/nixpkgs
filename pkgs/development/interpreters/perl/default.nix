{stdenv, fetchurl, patch}:

stdenv.mkDerivation {
  name = "perl-5.8.3";

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.cs.uu.nl/mirror/CPAN/src/5.0/perl-5.8.3.tar.gz;
    md5 = "6d2b389f8c6424b7af303f417947714f";
  };

  # This patch does the following:
  # 1) Do use the PATH environment variable to find the `pwd' command.
  #    By default, Perl will only look for it in /lib and /usr/lib.
  #    !!! what are the security implications of this?
  # 2) Force the use of <errno.h>, not /usr/include/errno.h, on Linux
  #    systems.  (This actually appears to be due to a bug in Perl.)

  srcPatch = ./patch;

  inherit patch;
}
