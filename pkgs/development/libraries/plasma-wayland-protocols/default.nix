{
  mkDerivation,
  fetchurl,
  lib,
  extra-cmake-modules,
  qtbase,
}:

mkDerivation rec {
  pname = "plasma-wayland-protocols";
  version = "1.14.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-GkOF7Px591ifBzgcqxHD/1H24vpLc7eGANatCWOUv4E=";
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
