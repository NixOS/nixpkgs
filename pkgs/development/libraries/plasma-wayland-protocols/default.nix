{ mkDerivation
, fetchurl
, lib
, extra-cmake-modules
, qtbase
}:

mkDerivation rec {
  pname = "plasma-wayland-protocols";
  version = "1.7.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-CE4mhcqmHZTG/obc4AayJHTXu0s0xMuWvXY7l+MF+tY=";
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
