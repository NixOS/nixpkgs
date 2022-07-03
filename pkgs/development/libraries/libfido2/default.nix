{ lib
, stdenv
, fetchurl
, cmake
, pkg-config
, hidapi
, libcbor
, openssl
, udev
, zlib
}:

stdenv.mkDerivation rec {
  pname = "libfido2";
  version = "1.10.0";

  # releases on https://developers.yubico.com/libfido2/Releases/ are signed
  src = fetchurl {
    url = "https://developers.yubico.com/${pname}/Releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-Um79PVavcGwF0J89IfGO47CxWsDB9cXaGsvCfCcwuZs=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libcbor openssl zlib ]
    ++ lib.optionals stdenv.isDarwin [ hidapi ]
    ++ lib.optionals stdenv.isLinux [ udev ];

  cmakeFlags = [
    "-DUDEV_RULES_DIR=${placeholder "out"}/etc/udev/rules.d"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DUSE_HIDAPI=1"
  ] ++ lib.optionals stdenv.isLinux [
    "-DNFC_LINUX=1"
  ];

  meta = with lib; {
    description = ''
      Provides library functionality for FIDO 2.0, including communication with a device over USB.
    '';
    homepage = "https://github.com/Yubico/libfido2";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill prusnak ];
    platforms = platforms.unix;
  };
}
