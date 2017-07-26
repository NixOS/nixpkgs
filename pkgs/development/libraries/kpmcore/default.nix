{ stdenv, lib, fetchurl, extra-cmake-modules, pkgconfig
, qtbase, kdeFrameworks
, eject, libatasmart, parted }:

let
  pname = "kpmcore";

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "3.0.3";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "17lqrp39w31fm7haigwq23cp92zwk3czjzqa2fhn3wafx3vafwd2";
  };

  buildInputs = [
    qtbase
    eject # this is to get libblkid
    libatasmart
    parted # we only need the library

    kdeFrameworks.kio
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
   maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
