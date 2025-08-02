{
  stdenv,
  lib,
  fetchurl,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  extra-cmake-modules,
  kcoreaddons,
  kpeople,
  kcontacts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kpeoplevcard";
  version = "0.1";

  src = fetchurl {
    url = "mirror://kde/stable/kpeoplevcard/${finalAttrs.version}/kpeoplevcard-${finalAttrs.version}.tar.xz";
    sha256 = "1hv3fq5k0pps1wdvq9r1zjnr0nxf8qc3vwsnzh9jpvdy79ddzrcd";
  };

  buildInputs = [
    kcoreaddons
    kpeople
    kcontacts
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
    extra-cmake-modules
  ];

  meta = {
    description = "Pulseaudio bindings for Qt";
    homepage = "https://github.com/KDE/kpeoplevcard";
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
