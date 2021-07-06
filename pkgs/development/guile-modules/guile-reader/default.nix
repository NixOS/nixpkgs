{ lib
, stdenv
, fetchurl
, fetchpatch
, gperf
, guile
, guile-lib
, libffi
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "guile-reader";
  version = "0.6.3";

  src = fetchurl {
    url = "http://download.savannah.nongnu.org/releases/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-OMK0ROrbuMDKt42QpE7D6/9CvUEMW4SpEBjO5+tk0rs=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    gperf
    guile
    guile-lib
    libffi
  ];

  GUILE_SITE="${guile-lib}/share/guile/site";

  configureFlags = [ "--with-guilemoduledir=$(out)/share/guile/site" ];

  meta = with lib; {
    homepage = "https://www.nongnu.org/guile-reader/";
    description = "A simple framework for building readers for GNU Guile";
    longDescription = ''
       Guile-Reader is a simple framework for building readers for GNU Guile.

       The idea is to make it easy to build procedures that extend Guile's read
       procedure. Readers supporting various syntax variants can easily be
       written, possibly by re-using existing "token readers" of a standard
       Scheme readers. For example, it is used to implement Skribilo's
       R5RS-derived document syntax.
    '';
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.gnu;
  };
}
