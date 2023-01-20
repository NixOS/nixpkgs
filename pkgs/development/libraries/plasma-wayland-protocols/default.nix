{ mkDerivation
, fetchurl
, lib
, extra-cmake-modules
, qtbase
}:

mkDerivation rec {
  pname = "plasma-wayland-protocols";
  version = "1.8.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-XQ+gyaC0SAAeCEJSQfI1/PuiW7xizkPAUK0dgI1X3Xo=";
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
