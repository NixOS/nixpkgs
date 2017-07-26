{ stdenv, fetchurl, qt4, qca2, qmake4Hook }:

stdenv.mkDerivation {
  name = "qoauth-1.0.1";

  src = fetchurl {
    url = https://github.com/ayoy/qoauth/tarball/v1.0.1;
    name = "qoauth-1.0.1.tar.gz";
    sha256 = "1ax0g4dd49a3a1699ams13bkhz690xfwqg8rxp1capbdpf2aa8cp";
  };

  patchPhase = "sed -e 's/lib64/lib/g' -i src/src.pro";

  buildInputs = [ qt4 qca2 ];
  nativeBuildInputs = [ qmake4Hook ];

  NIX_CFLAGS_COMPILE = [ "-I${qca2}/include/QtCrypto" ];
  NIX_LDFLAGS = [ "-lqca" ];

  meta = {
    description = "Qt library for OAuth authentication";
    inherit (qt4.meta) platforms;
    maintainers = [ ];
  };
}
