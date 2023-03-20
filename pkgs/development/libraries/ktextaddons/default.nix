{ lib, mkDerivation, fetchurl, cmake, extra-cmake-modules, karchive, kconfigwidgets, kcoreaddons, ki18n, kxmlgui, qtkeychain }:
mkDerivation rec {
  pname = "ktextaddons";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-BV1tHCD6kGI5Zj8PRZcEanLi1O7huS+qUijjtePDvik=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ karchive kconfigwidgets kcoreaddons ki18n kxmlgui qtkeychain ];

  meta = with lib; {
    description = "Various text handling addons for KDE applications";
    homepage = "https://invent.kde.org/libraries/ktextaddons/";
    license = licenses.gpl2Plus;
    maintainers = [];
  };
}
