{ stdenv, fetchurl, fetchpatch, pkgconfig
, gperf, guile, guile-lib, libffi }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "guile-reader-${version}";
  version = "0.6.2";

  src = fetchurl {
    url = "http://download.savannah.nongnu.org/releases/guile-reader/${name}.tar.gz";
    sha256 = "0592s2s8ampqmqwilc4fvcild6rb9gy79di6vxv5kcdmv23abkgx";
  };

  patches = [
    (fetchpatch {
       name = "0001-fix-prototypes.patch";
       url = https://aur.archlinux.org/cgit/aur.git/plain/reader_flag.patch?h=guile-reader&id=63ac0413a1aa65eb6a0db57bc16ef4481b70dc31;
       sha256 = "01ar34xgpxyli8v2bk4kj6876kyrxhxhfpv9v07lx36d254bzrjb";
     }) ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gperf guile guile-lib libffi ];

  GUILE_SITE="${guile-lib}/share/guile/site";

  configureFlags = [ "--with-guilemoduledir=$(out)/share/guile/site" ];

  meta = with stdenv.lib; {
    description = "A simple framework for building readers for GNU Guile";
    longDescription = ''
       Guile-Reader is a simple framework for building readers for GNU
       Guile.

       The idea is to make it easy to build procedures that extend
       Guile's read procedure. Readers supporting various syntax
       variants can easily be written, possibly by re-using existing
       "token readers" of a standard Scheme readers. For example, it
       is used to implement Skribilo's R5RS-derived document syntax.
    '';
    homepage = https://www.gnu.org/software/guile-reader;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.gnu;
  };
}
