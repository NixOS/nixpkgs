{ stdenv
, fetchurl
, fetchpatch
, cmake
, pkgconfig
, libcbor
, openssl
, udev
, IOKit }:

stdenv.mkDerivation rec {
  pname = "libfido2";
  version = "1.3.1";
  src = fetchurl {
    url = "https://developers.yubico.com/${pname}/Releases/${pname}-${version}.tar.gz";
    sha256 = "0hdgxbmjbnm9kjwc07nrl2zy87qclvb3rzvdwr5iw35n2qhf4dds";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ libcbor openssl ]
    ++ stdenv.lib.optionals stdenv.isLinux [ udev ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  patches = [
    # fix build on darwin
    (fetchpatch {
      url = "https://github.com/Yubico/libfido2/commit/916ebd18a89e4028de203d603726805339be7a5b.patch";
      sha256 = "07f0xpxnq02cccmqcric87b6pms7k7ssvdw722zr970a6qs8p6i7";
    })
    # allow attestation using any supported algorithm
    (fetchpatch {
      url = "https://github.com/Yubico/libfido2/commit/f7a9471fa0588cb91cbefffb13c1e4d06c2179b7.patch";
      sha256 = "02qbw9bqy3sixvwig6az7v3vimgznxnfikn9p1jczm3d7mn8asw2";
    })
    # fix EdDSA attestation signature verification bug
    (fetchpatch {
      url = "https://github.com/Yubico/libfido2/commit/95126eea52294419515e6540dfd7220f35664c48.patch";
      sha256 = "076mwpl9xndjhy359jdv2drrwyq7wd3pampkn28mn1rlwxfgf0d0";
    })
  ];

  cmakeFlags = [
    "-DUDEV_RULES_DIR=${placeholder "out"}/etc/udev/rules.d"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = with stdenv.lib; {
    description = ''
    Provides library functionality for FIDO 2.0, including communication with a device over USB.
    '';
    homepage = https://github.com/Yubico/libfido2;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill prusnak ];
    platforms = platforms.unix;
  };
}
