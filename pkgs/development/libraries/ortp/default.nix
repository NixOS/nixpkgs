{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "ortp-0.16.3";

  src = fetchurl {
    url = "mirror://savannah/linphone/ortp/sources/${name}.tar.gz";
    sha256 = "13805ec34ee818408aa1b4571915ef8f9e544c838a0fca9dff8d2308de6574eb";
  };

  meta = {
    description = "A Real-Time Transport Protocol (RFC3550) stack";
    homepage = http://www.linphone.org/index.php/eng/code_review/ortp;
  };
}
