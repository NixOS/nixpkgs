{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ortp-0.18.0";

  src = fetchurl {
    url = "mirror://savannah/linphone/ortp/sources/${name}.tar.gz";
    sha256 = "1cgx9xid0abk3cad3xjdvx7p9whinlhrviphyrd9zkhhx7ddkih2";
  };

  meta = {
    description = "A Real-Time Transport Protocol (RFC3550) stack";
    homepage = http://www.linphone.org/index.php/eng/code_review/ortp;
  };
}
