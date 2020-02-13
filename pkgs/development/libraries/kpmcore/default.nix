{ stdenv, lib, fetchurl, extra-cmake-modules
, qtbase, qca-qt5, kdeFrameworks
, smartmontools, parted
, utillinux }:

let
  pname = "kpmcore";

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "4.1.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "0jsig7algmab9h0fb09my0axjqzw83zgscamhzl8931lribs6idm";
  };

  buildInputs = [
    qtbase qca-qt5
    smartmontools
    parted # we only need the library

    kdeFrameworks.kauth
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
