{ stdenv, lib, fetchurl, extra-cmake-modules
, qtbase, qca-qt5, kdeFrameworks
, smartmontools, parted
, utillinux }:

let
  pname = "kpmcore";

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "4.0.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "0vfz9pr9n6p9hs3d9cm8yirp9mkw76nhnin55v3bwsb34p549w6p";
  };

  buildInputs = [
    qtbase qca-qt5
    smartmontools
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
