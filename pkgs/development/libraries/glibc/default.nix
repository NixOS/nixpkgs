{stdenv, fetchurl, kernelHeaders, installLocales ? true}:

stdenv.mkDerivation {
  name = "glibc-2.3.3";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/glibc/glibc-2.3.3.tar.bz2;
    md5 = "e825807b98042f807799ccc9dd96d31b";
  };
  linuxthreadsSrc = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/glibc/glibc-linuxthreads-2.3.3.tar.bz2;
    md5 = "8149ea62922e75bd692bc3b92e5e766b";
  };

  patches = [
    # This patch fixes the bug
    # http://sources.redhat.com/bugzilla/show_bug.cgi?id=312.  Note
    # that this bug was marked as `WORKSFORME' with the comment to
    # just use glibc from CVS.  This and the unholy Linuxthreads/NPTL
    # mess proves that glibc, together with the Linux kernel,
    # constitutes an AXIS OF EVIL wrt release management.  Patch
    # obtained from
    # http://www.pengutronix.de/software/ptxdist/patches-cvs/glibc-2.3.2/generic/fixup.patch.
    ./fixup.patch

    # Likewise, this fixes the bug reported in
    # http://sources.redhat.com/ml/libc-alpha/2003-07/msg00117.html.
    # Die, glibc, die.
    ./no-unit-at-a-time.patch

    # This is a patch to make glibc compile under GCC 3.3.  Presumably
    # later releases of glibc won't need this.
#    ./glibc-2.3.2-sscanf-1.patch
  ];

  inherit kernelHeaders installLocales;
}
