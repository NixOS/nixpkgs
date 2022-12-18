{ stdenv, lib, cmake, qt4, fetchzip }:

stdenv.mkDerivation rec {
  pname = "smokegen";
  version = "4.14.3";

  src = fetchzip {
    url = "https://invent.kde.org/unmaintained/${pname}/-/archive/v${version}/${pname}-v${version}.tar.gz";
    hash = "sha256-finsoruPeJZLawIjNUJ25Pq54eaCByfALVraNQJPk7c=";
  };

  strictDeps = true;
  nativeBuildInputs = [ cmake qt4 ];
  buildInputs = [ qt4 ];

  meta = with lib; {
    description = "A general purpose C++ parser with a plugin infrastructure";
    homepage = "https://invent.kde.org/unmaintained/smokegen";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ uthar ];
  };
}
