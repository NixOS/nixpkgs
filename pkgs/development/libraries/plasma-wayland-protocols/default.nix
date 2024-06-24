{ mkDerivation
, fetchurl
, lib
, extra-cmake-modules
, qtbase
}:

mkDerivation rec {
  pname = "plasma-wayland-protocols";
  version = "1.13.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-3Ud+NS9f9uasaGKGxLIrGb9aSSG4XuWn2gK7eqEV1X4=";
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
