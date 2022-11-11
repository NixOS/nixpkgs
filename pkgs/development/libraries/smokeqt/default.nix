{ pkgs, lib, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "smokeqt";
  version = "v4.14.3";
  src = pkgs.fetchzip {
    url = "https://invent.kde.org/unmaintained/${pname}/-/archive/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-8FiEGF8gduVw5I/bi2wExGUWmjIjYEhWpjpXKJGBNMg=";
  };
  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=98"
  ];
  buildInputs = [ pkgs.cmake pkgs.qt4 pkgs.smokegen ];
  meta = with lib; {
    description = "Bindings for the Qt libraries";
    homepage = "https://invent.kde.org/unmaintained/smokeqt";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ uthar ];
  };
}
