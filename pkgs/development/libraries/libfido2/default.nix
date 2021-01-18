{ stdenv
, fetchurl
, fetchpatch
, cmake
, pkgconfig
, hidapi
, libcbor
, openssl
, udev
}:

stdenv.mkDerivation rec {
  pname = "libfido2";
  version = "1.5.0";
  src = fetchurl {
    url = "https://developers.yubico.com/${pname}/Releases/${pname}-${version}.tar.gz";
    sha256 = "08iizxq3w8mpkwfrfpl59csffc20yz8x398bl3kf23rrr4izk42r";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ hidapi libcbor openssl ]
    ++ stdenv.lib.optionals stdenv.isLinux [ udev ];

  cmakeFlags = [
    "-DUDEV_RULES_DIR=${placeholder "out"}/etc/udev/rules.d"
    "-DUSE_HIDAPI=1"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = with stdenv.lib; {
    description = ''
    Provides library functionality for FIDO 2.0, including communication with a device over USB.
    '';
    homepage = "https://github.com/Yubico/libfido2";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill prusnak ];
    platforms = platforms.unix;
  };
}
