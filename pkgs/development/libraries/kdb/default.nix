{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules,
  qtbase, qttranslations, kcoreaddons, python2, sqlite, postgresql, libmysqlclient
}:

mkDerivation rec {
  pname = "kdb";
  version = "3.2.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/src/${pname}-${version}.tar.xz";
    sha256 = "0s909x34a56n3xwhqz27irl2gbzidax0685w2kf34f0liny872cg";
  };

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [ qttranslations kcoreaddons python2 sqlite postgresql libmysqlclient ];

  propagatedBuildInputs = [ qtbase ];

  meta = with lib; {
    description = "A database connectivity and creation framework for various database vendors";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zraexy ];
  };
}
