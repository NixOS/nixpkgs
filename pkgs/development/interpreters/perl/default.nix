{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "perl-5.8.5";

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.cs.uu.nl/mirror/CPAN/src/5.0/perl-5.8.5.tar.gz;
    md5 = "49baa8d7d29b4a9713c06edeb81e6b1b";
  };

  # This patch does the following:
  # 1) Do use the PATH environment variable to find the `pwd' command.
  #    By default, Perl will only look for it in /lib and /usr/lib.
  #    !!! what are the security implications of this?
  # 2) Force the use of <errno.h>, not /usr/include/errno.h, on Linux
  #    systems.  (This actually appears to be due to a bug in Perl.)
  patches = [./no-sys-dirs.patch];
}
