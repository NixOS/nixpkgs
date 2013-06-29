{stdenv, fetchurl, srtp, libzrtpcpp, pkgconfig }:

stdenv.mkDerivation rec {
  name = "ortp-0.22.0";

  src = fetchurl {
    url = "mirror://savannah/linphone/ortp/sources/${name}.tar.gz";
    sha256 = "02rdm6ymgblbx8fnjfvivkl4qkgbdizrf35fyb0vln9m7jdy4dvf";
  };

  configureFlags = "--enable-zrtp";

  propagatedBuildInputs = [ srtp libzrtpcpp pkgconfig ];

  meta = {
    description = "A Real-Time Transport Protocol (RFC3550) stack";
    homepage = http://www.linphone.org/index.php/eng/code_review/ortp;
  };
}
