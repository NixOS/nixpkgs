{ stdenv, lib, fetchurl, extra-cmake-modules, pkgconfig
, qtbase, kdeFrameworks
, eject, libatasmart, parted }:

let
  pname = "kpmcore";

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "3.3.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "0s6v0jfrhjg31ri5p6h9n4w29jvasf5dj954j3vfpzl91lygmmmq";
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
