{ stdenv, fetchurl, cmake, pkgconfig, libcbor, libressl, udev }:

stdenv.mkDerivation rec {
  pname = "libfido2";
  version = "1.1.0";
  src = fetchurl {
    url = "https://developers.yubico.com/libfido2/Releases/libfido2-${version}.tar.gz";
    sha256 = "1h51q9pgv54czf7k6v90b02gnvqw4dlxmz6vi0n06shpkdzv5jh1";
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
