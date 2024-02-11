{ stdenv
, lib
, fetchurl
, cmake
, pkg-config
, extra-cmake-modules
, wrapQtAppsHook
, pulseaudio
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pulseaudio-qt";
  version = "1.3.0";

  src = fetchurl {
    url = "mirror://kde/stable/${finalAttrs.pname}/${finalAttrs.pname}-${lib.versions.majorMinor finalAttrs.version}.tar.xz";
    sha256 = "1i4yb0v1mmhih8c2i61hybg6q60qys3pc5wbjb7a0vwl1mihgsxw";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    pulseaudio
  ];

  meta = with lib; {
    description = "Pulseaudio bindings for Qt";
    homepage    = "https://invent.kde.org/libraries/pulseaudio-qt";
    license     = with licenses; [ lgpl2 ];
    maintainers = with maintainers; [ doronbehar ];
  };
})
