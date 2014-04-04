{ stdenv, cracklib, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "libpwquality-1.2.3";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/i/libpwquality/${name}.tar.bz2";
    sha256 = "0sjiabvl5277nfxyy96jdz65a0a3pmkkwrfbziwgik83gg77j75i";
  };

  buildInputs = [ cracklib python ];
}
