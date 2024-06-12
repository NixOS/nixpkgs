{ stdenv, lib, fetchurl, cmake, extra-cmake-modules, qtbase }:
stdenv.mkDerivation rec {
  pname = "futuresql";
  version = "0.1.1";

  src = fetchurl {
    url = "mirror://kde/stable/futuresql/futuresql-${version}.tar.xz";
    hash = "sha256-5E7Y1alhizynuimD7ZxfdXLm4KWxmflIaINLccy+vUM=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];
  buildInputs = [ qtbase ];
  cmakeFlags = ["-DQT_MAJOR_VERSION=${lib.versions.major qtbase.version}"];

  # a library, nothing to wrap
  dontWrapQtApps = true;
}
