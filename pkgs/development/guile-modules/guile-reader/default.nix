{ lib
, stdenv
, fetchurl
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  env.GUILE_SITE = "${guile-lib}/${guile.siteDir}";

  configureFlags = [ "--with-guilemoduledir=$(out)/${guile.siteDir}" ];
=======
  GUILE_SITE="${guile-lib}/share/guile/site";

  configureFlags = [ "--with-guilemoduledir=$(out)/share/guile/site" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    platforms = guile.meta.platforms;
=======
    platforms = platforms.gnu;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
