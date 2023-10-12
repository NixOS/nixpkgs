{ stdenv, fetchurl, cmake, extra-cmake-modules, qtbase }:
stdenv.mkDerivation rec {
  pname = "futuresql";
  version = "0.1.1";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-5E7Y1alhizynuimD7ZxfdXLm4KWxmflIaINLccy+vUM=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ qtbase ];

  # a library, nothing to wrap
  dontWrapQtApps = true;
}
