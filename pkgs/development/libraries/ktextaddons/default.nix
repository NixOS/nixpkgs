{
  lib,
  mkDerivation,
  fetchurl,
  cmake,
  extra-cmake-modules,
  karchive,
  kconfigwidgets,
  kcoreaddons,
  ki18n,
  kxmlgui,
  qtkeychain,
}:
mkDerivation rec {
  pname = "ktextaddons";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-mB7Hh2Ljrg8D2GxDyHCa1s6CVmg5DDkhwafEqtSqUeM=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    karchive
    kconfigwidgets
    kcoreaddons
    ki18n
    kxmlgui
    qtkeychain
  ];

  meta = with lib; {
    description = "Various text handling addons for KDE applications";
    homepage = "https://invent.kde.org/libraries/ktextaddons/";
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
