/* Pthread man pages from LinuxThreads.

   Some of these pages are superseded by those in the `man-pages'
   package, but not all.  Like other distros (e.g., Debian's
   `glibc-doc' package) we take man pages from LinuxThreads so that
   we can cover pretty much all of pthreads.  */

{ fetchurl, stdenv, perl }:

let version = "2.3.6";
in
  stdenv.mkDerivation rec {
    name = "pthread-man-pages-${version}";

    src = fetchurl {
      url = "mirror://gnu/glibc/glibc-linuxthreads-${version}.tar.bz2";
      sha256 = "0f56msimlyfmragqa69jd39rb47h09l9b0agn67k1rfi8yic8fvc";
    };

    buildInputs = [ perl ];

    unpackPhase = ''
      echo "unpacking to \`${name}'"
      mkdir "${name}"
      cd "${name}"
      tar xjvf "$src"
    '';

    patchPhase = ''
      ensureDir "$out/share/man/man3"

      sed -i "linuxthreads/man/Makefile" \
          -e "s|MANDIR *=.*$|MANDIR = $out/share/man/man3| ;
              s|3thr|3|g"
    '';

    preConfigure = "cd linuxthreads/man";

    postInstall = ''
      chmod a-x $out/share/man/man3/*.3
    '';

    meta = {
      description = "POSIX threads (pthreads) manual pages from LinuxThreads";
      homepage = http://www.gnu.org/software/libc/;
    };
  }
