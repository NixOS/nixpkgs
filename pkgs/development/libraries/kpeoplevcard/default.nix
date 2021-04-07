{ mkDerivation
, lib
, fetchurl
, cmake
, extra-cmake-modules
, pkg-config
, kcoreaddons
, kpeople
, kcontacts
}:

mkDerivation rec {
  pname = "kpeoplevcard";
  version = "0.1";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "1hv3fq5k0pps1wdvq9r1zjnr0nxf8qc3vwsnzh9jpvdy79ddzrcd";
  };

  buildInputs = [
    kcoreaddons
    kpeople
    kcontacts
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    extra-cmake-modules
  ];

  meta = with lib; {
    description = "Pulseaudio bindings for Qt";
    homepage    = "https://github.com/KDE/kpeoplevcard";
    license     = with licenses; [ lgpl2 ];
    maintainers = with maintainers; [ doronbehar ];
  };
}

