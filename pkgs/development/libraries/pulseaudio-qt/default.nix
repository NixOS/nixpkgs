{ mkDerivation
, lib
, fetchurl
, cmake
, extra-cmake-modules
, pkg-config
, pulseaudio
}:

mkDerivation rec {
  pname = "pulseaudio-qt";
  version = "1.3.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${lib.versions.majorMinor version}.tar.xz";
    sha256 = "1i4yb0v1mmhih8c2i61hybg6q60qys3pc5wbjb7a0vwl1mihgsxw";
  };

  buildInputs = [
    pulseaudio
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    extra-cmake-modules
  ];

  meta = with lib; {
    description = "Pulseaudio bindings for Qt";
    homepage    = "https://invent.kde.org/libraries/pulseaudio-qt";
    license     = with licenses; [ lgpl2 ];
    maintainers = with maintainers; [ doronbehar ];
  };
}
