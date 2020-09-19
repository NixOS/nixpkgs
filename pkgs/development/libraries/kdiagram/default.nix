{
  mkDerivation, fetchurl, lib,
  extra-cmake-modules, qttools,
  qtbase, qtsvg,
}:

let
  pname = "kdiagram";
  version = "2.7.0";
in

mkDerivation {
  inherit pname version;
  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256:1pgvf2q8b59hw0jg5ajmj5nrn4q8cgnifpvdd0fynk2ml6zym8k3";
  };
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  propagatedBuildInputs = [ qtbase qtsvg ];
  meta = {
    description = "Libraries for creating business diagrams";
    license = lib.licenses.gpl2;
    platforms = qtbase.meta.platforms;
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
