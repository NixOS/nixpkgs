{ stdenv, fetchurl, cmake, pkgconfig, libcbor, libressl, udev, IOKit }:

stdenv.mkDerivation rec {
  pname = "libfido2";
  version = "1.3.1";
  src = fetchurl {
    url = "https://developers.yubico.com/${pname}/Releases/${pname}-${version}.tar.gz";
    sha256 = "0hdgxbmjbnm9kjwc07nrl2zy87qclvb3rzvdwr5iw35n2qhf4dds";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libcbor libressl ]
    ++ stdenv.lib.optionals stdenv.isLinux [ udev ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  patches = [ ./detect_apple_ld.patch ];

  cmakeFlags = [ "-DUDEV_RULES_DIR=${placeholder "out"}/etc/udev/rules.d"
                 "-DCMAKE_INSTALL_LIBDIR=lib" ];

  meta = with stdenv.lib; {
    description = ''
    Provides library functionality for FIDO 2.0, including communication with a device over USB.
    '';
    homepage = https://github.com/Yubico/libfido2;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.unix;
  };
}
