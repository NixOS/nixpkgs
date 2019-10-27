{ stdenv, lib, fetchurl, extra-cmake-modules
, qtbase, kdeFrameworks
, libatasmart, parted
, utillinux }:

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
    libatasmart
    parted # we only need the library

    kdeFrameworks.kio

    utillinux # needs blkid (note that this is not provided by utillinux-compat)
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    maintainers = with lib.maintainers; [ peterhoeg ];
    # The build requires at least Qt 5.12:
    broken = lib.versionOlder qtbase.version "5.12.0";
  };
}
