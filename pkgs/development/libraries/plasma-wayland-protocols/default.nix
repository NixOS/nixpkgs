{ mkDerivation, fetchurl, lib
, extra-cmake-modules
, qtbase
}:

mkDerivation rec {
  pname = "plasma-wayland-protocols";
  version = "1.2.1";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-v${version}.tar.xz";
    sha256 = "sha256-KHuQkD+afzlMdedcsYdCaGLq9kqS8b5+LvaOmf2Muqo=";
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
