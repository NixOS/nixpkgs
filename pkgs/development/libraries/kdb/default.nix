{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules,
  qtbase, qttranslations, kcoreaddons, python2, sqlite, postgresql, mysql
}:

mkDerivation rec {
  pname = "kdb";
  version = "3.1.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/src/${name}.tar.xz";
    sha256 = "1wi9z7j0nr9wi6aqqkdcpnr38ixyxbv00sblya7pakdf96hlamhp";
  };

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [ qttranslations kcoreaddons python2 sqlite postgresql mysql.connector-c ];

  propagatedBuildInputs = [ qtbase ];

  meta = with lib; {
    description = "A database connectivity and creation framework for various database vendors";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zraexy ];
  };
}
