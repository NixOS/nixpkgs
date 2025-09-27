{
  mkDerivation,
  fetchurl,
  lib,
  extra-cmake-modules,
  qtbase,
}:

mkDerivation rec {
  pname = "plasma-wayland-protocols";
  version = "1.19.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-RWef56Y8QU8sgXk6YlKPrmzO5YS2llcZ1/n8bdSLqEY=";
  };

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [ qtbase ];

  meta = {
    description = "Plasma Wayland Protocols";
    license = lib.licenses.lgpl21Plus;
    platforms = qtbase.meta.platforms;
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
