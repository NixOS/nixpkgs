{
  mkDerivation,
  fetchurl,
  lib,
  extra-cmake-modules,
  qtbase,
}:

mkDerivation rec {
  pname = "plasma-wayland-protocols";
  version = "1.15.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-5a7f58CyRDqmeIK0eS0IgUVw4A3YL3GaNckioJk/Yh4=";
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
