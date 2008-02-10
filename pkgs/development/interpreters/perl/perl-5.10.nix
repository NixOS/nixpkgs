{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "perl-5.10.0";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cpan.org/src/perl-5.10.0.tar.gz;
    sha256 = "0bivbz15x02m02gqs6hs77cgjr2msfrhnvp5xqk359jg6w6llill";
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
