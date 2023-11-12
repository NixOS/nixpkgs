{ mkDerivation
, fetchurl
, lib
, extra-cmake-modules
, qtbase
}:

mkDerivation rec {
  pname = "plasma-wayland-protocols";
  version = "1.11.1";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-RRqokEMc7lBm+pO/jANkChi1WVYhoYo1sfd3r9UBhs0=";
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
