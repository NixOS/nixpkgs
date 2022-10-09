{ pkgs, lib, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "smokegen";
  version = "v4.14.3";
  src = pkgs.fetchzip {
    url = "https://invent.kde.org/unmaintained/${pname}/-/archive/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-finsoruPeJZLawIjNUJ25Pq54eaCByfALVraNQJPk7c=";
  };
  buildInputs = [ pkgs.cmake pkgs.qt4 ];
  buildPhase = ''
      cmake .
    '';
  meta = with lib; {
    description = "A general purpose C++ parser with a plugin infrastructure";
    homepage = "https://invent.kde.org/unmaintained/smokegen";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ uthar ];
  };
}
