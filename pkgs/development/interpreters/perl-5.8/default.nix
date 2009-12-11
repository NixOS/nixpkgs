{ stdenv, fetchurl
, impureLibcPath ? null
}:

stdenv.mkDerivation {
  name = "perl-5.8.8";

  phases = "phase";
  phase =
   ''
source $stdenv/setup

if test "$NIX_ENFORCE_PURITY" = "1"; then
    GLIBC=${if impureLibcPath == null then "$(cat $NIX_GCC/nix-support/orig-libc)" else impureLibcPath}
    extraflags="-Dlocincpth=$GLIBC/include -Dloclibpth=$GLIBC/lib"
fi

configureScript=./Configure
configureFlags="-de -Dcc=gcc -Dprefix=$out -Uinstallusrbinperl $extraflags"
dontAddPrefix=1

preBuild() {
    # Make Cwd work on NixOS (where we don't have a /bin/pwd).
    substituteInPlace lib/Cwd.pm --replace "'/bin/pwd'" "'$(type -tP pwd)'"
}

postInstall() {
    ensureDir "$out/nix-support"
    cp $setupHook $out/nix-support/setup-hook
}

unset phases
genericBuild

   '';

  src = fetchurl {
    url = mirror://cpan/src/perl-5.8.8.tar.bz2;
    sha256 = "1j8vzc6lva49mwdxkzhvm78dkxyprqs4n4057amqvsh4kh6i92l1";
  };

  patches = [
    # This patch does the following:
    # 1) Do use the PATH environment variable to find the `pwd' command.
    #    By default, Perl will only look for it in /lib and /usr/lib.
    #    !!! what are the security implications of this?
    # 2) Force the use of <errno.h>, not /usr/include/errno.h, on Linux
    #    systems.  (This actually appears to be due to a bug in Perl.)
    ./no-sys-dirs.patch

    # Patch to make Perl 5.8.8 build with GCC 4.2.  Taken from
    # http://www.nntp.perl.org/group/perl.perl5.porters/2006/11/msg117738.html
    ./gcc-4.2.patch

    # Fix for "SysV.xs:7:25: error: asm/page.h: No such file or
    # directory" on recent kernel headers.  From
    # http://bugs.gentoo.org/show_bug.cgi?id=168312.
    (fetchurl {
      url = http://bugs.gentoo.org/attachment.cgi?id=111427;
      sha256 = "017pj0nbqb7kwj3cs727c2l2d8c45l9cwxf71slgb807kn3ppgmn";
    })
  ];

  setupHook = ./setup-hook.sh;
}
