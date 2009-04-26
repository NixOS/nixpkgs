{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ortp-0.13.1";

  src = fetchurl {
    url = "mirror://savannah/linphone/ortp/sources/${name}.tar.gz";
    sha256 = "0k2963v4b15xnf4cpkpgjhsb8ckxpf6vdr8dnw7z3mzilji7391b";
  };

  meta = {
    description = "A Real-Time Transport Protocol (RFC3550) stack";
    homepage = http://www.linphone.org/index.php/eng/code_review/ortp;
  };
}
