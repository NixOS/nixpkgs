{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ortp-0.16.4";

  src = fetchurl {
    url = "mirror://savannah/linphone/ortp/sources/${name}.tar.gz";
    sha256 = "0yb835l9spic4518ghb28jlwc0ihqjzpd0bgysgjf7z3bbg7km90";
  };

  meta = {
    description = "A Real-Time Transport Protocol (RFC3550) stack";
    homepage = http://www.linphone.org/index.php/eng/code_review/ortp;
  };
}
