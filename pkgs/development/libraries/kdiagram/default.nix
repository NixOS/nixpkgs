{
  mkDerivation, fetchurl, lib,
  extra-cmake-modules, qttools,
  qtbase, qtsvg,
}:

mkDerivation {
  name = "kdiagram-2.6.0";
  src = fetchurl {
    url = "https://download.kde.org/stable/kdiagram/2.6.0/src/kdiagram-2.6.0.tar.xz";
    sha256 = "10hqk12wwgbiq4q5145s8v7v96j621ckq1yil9s4pihmgsnqsy02";
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
