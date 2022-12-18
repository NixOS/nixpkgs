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
, withPcsclite ? true
, pcsclite
}:

stdenv.mkDerivation rec {
  pname = "libfido2";
  version = "1.12.0";

  # releases on https://developers.yubico.com/libfido2/Releases/ are signed
  src = fetchurl {
    url = "https://developers.yubico.com/${pname}/Releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-gT1tJRFhQ9FtLpZ5FxinSCXaFrd0qNCT2W8Grhcw2cU=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libcbor zlib ]
    ++ lib.optionals stdenv.isDarwin [ hidapi ]
    ++ lib.optionals stdenv.isLinux [ udev ]
    ++ lib.optionals (stdenv.isLinux && withPcsclite) [ pcsclite ];

  propagatedBuildInputs = [ openssl ];

  outputs = [ "out" "dev" "man" ];

  cmakeFlags = [
    "-DUDEV_RULES_DIR=${placeholder "out"}/etc/udev/rules.d"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DUSE_HIDAPI=1"
  ] ++ lib.optionals stdenv.isLinux [
    "-DNFC_LINUX=1"
  ] ++ lib.optionals (stdenv.isLinux && withPcsclite) [
    "-DUSE_PCSC=1"
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
