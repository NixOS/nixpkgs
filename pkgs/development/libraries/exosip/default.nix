{ lib, stdenv, fetchurl, libosip, openssl, pkg-config }:

stdenv.mkDerivation rec {
 pname = "libexosip2";
 version = "5.2.0";

 src = fetchurl {
    url = "mirror://savannah/exosip/${pname}-${version}.tar.gz";
    sha256 = "09bj7cm6mk8yr68y5a09a625x10ql6an3zi4pj6y1jbkhpgqibp3";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libosip openssl ];

  meta = with lib; {
    license = licenses.gpl2Plus;
    description = "Library that hides the complexity of using the SIP protocol";
    platforms = platforms.linux;
  };
}
