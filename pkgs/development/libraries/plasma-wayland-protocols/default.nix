{ mkDerivation
, fetchurl
, lib
, extra-cmake-modules
, qtbase
}:

mkDerivation rec {
  pname = "plasma-wayland-protocols";
  version = "1.10.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-MZSIZ8mgRhPm3g0jrfy8Ws7N3vCzn5hrNF7GwZcnNv4=";
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
