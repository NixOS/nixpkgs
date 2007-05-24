{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "perl-5.8.8";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.funet.fi/pub/CPAN/src/perl-5.8.8.tar.bz2;
    sha256 = "1j8vzc6lva49mwdxkzhvm78dkxyprqs4n4057amqvsh4kh6i92l1";
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
