{ stdenv, lib, cmake, qt4, smokegen, fetchzip }:

stdenv.mkDerivation rec {
  pname = "smokeqt";
  version = "4.14.3";

  src = fetchzip {
    url = "https://invent.kde.org/unmaintained/${pname}/-/archive/v${version}/${pname}-v${version}.tar.gz";
    hash = "sha256-8FiEGF8gduVw5I/bi2wExGUWmjIjYEhWpjpXKJGBNMg=";
  };

  strictDeps = true;
  nativeBuildInputs = [ cmake smokegen ];
  buildInputs = [ qt4 ];

  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=98"
  ];

  meta = with lib; {
    description = "Bindings for the Qt libraries";
    homepage = "https://invent.kde.org/unmaintained/smokeqt";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ uthar ];
  };
}
