{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules,
  qtbase, qttranslations, kcoreaddons, python2, sqlite, postgresql, libmysql
}:

mkDerivation rec {
  pname = "kdb";
  version = "3.0.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/src/${name}.tar.xz";
    sha256 = "1n11xhqk3sf4a5nzvnrnj7bj21yqqqkm2d1xzfx3q82fkyah8s49";
  };

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [ qttranslations kcoreaddons python2 sqlite postgresql libmysql ];

  propagatedBuildInputs = [ qtbase ];

  meta = with lib; {
    description = "A database connectivity and creation framework for various database vendors";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zraexy ];
  };
}
