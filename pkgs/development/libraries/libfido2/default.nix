{ stdenv, fetchurl, cmake, pkgconfig, libcbor, libressl, udev }:

stdenv.mkDerivation rec {
  pname = "libfido2";
  version = "1.0.0";
  src = fetchurl {
    url = "https://developers.yubico.com/libfido2/Releases/libfido2-${version}.tar.gz";
    sha256 = "1l0f67fpza0lhq08brpgi4xyfw60w1q790a83x8vqm889l4mph8w";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libcbor libressl udev ];

  cmakeFlags = [ "-DUDEV_RULES_DIR=${placeholder "out"}/etc/udev/rules.d" ];

  meta = with stdenv.lib; {
    description = ''
    Provides library functionality for FIDO 2.0, including communication with a device over USB.
    '';
    homepage = https://github.com/Yubico/libfido2;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];

  };
}
