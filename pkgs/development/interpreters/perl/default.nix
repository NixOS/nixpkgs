{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "perl-5.8.6";

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.cpan.org/pub/CPAN/src/5.0/perl-5.8.6.tar.bz2;
    md5 = "3d030b6ff2a433840edb1a407d18dc0a";
  };

  # This patch does the following:
  # 1) Do use the PATH environment variable to find the `pwd' command.
  #    By default, Perl will only look for it in /lib and /usr/lib.
  #    !!! what are the security implications of this?
  # 2) Force the use of <errno.h>, not /usr/include/errno.h, on Linux
  #    systems.  (This actually appears to be due to a bug in Perl.)
  patches = [./no-sys-dirs.patch];

  setupHook = ./setup-hook.sh;
}
