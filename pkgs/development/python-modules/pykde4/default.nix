{ pyqt4, openssl_1_0_2
, stdenv, callPackage, fetchurl, cmake, automoc4, sip }:

let
  kdelibs = callPackage ./kdelibs.nix {
    openssl = openssl_1_0_2;
  };
  sip4_19_3 = sip.overrideAttrs (oldAttrs: rec {
    src = fetchurl {
      url = "mirror://sourceforge/pyqt/sip/sip-4.19.3/sip-4.19.3.tar.gz";
      sha256 = "0x2bghbprwl3az1ni3p87i0bq8r99694la93kg65vi0cz12gh3bl";
    };
  });
  pyqt4_fixed = pyqt4.overrideAttrs (oldAttrs: {
    propagatedBuildInputs = [ sip4_19_3 ];
  });
in stdenv.mkDerivation rec {
  version = "4.14.3";
  pname = "pykde4";

  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/${pname}-${version}-${version}.tar.xz";
    sha256 = "1z40gnkyjlv6ds3cmpzvv99394rhmydr6rxx7qj33m83xnsxgfbz";
  };

  patches = [ ./dlfcn.patch ];

  buildInputs = [
    kdelibs
  ];

  nativeBuildInputs = [ cmake automoc4 ];

  propagatedBuildInputs = [ pyqt4_fixed ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    description = "Python bindings for KDE";
    license = with licenses; [ gpl2 lgpl2 ];
    homepage = https://api.kde.org/pykde-4.3-api/;
    maintainers = with maintainers; [ gnidorah ];
  };
}
