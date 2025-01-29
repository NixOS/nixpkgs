{
  mkDerivation,
  fetchFromGitLab,
  lib,
  extra-cmake-modules,
  qttools,
  qtbase,
  qtsvg,
}:

mkDerivation rec {
  pname = "kdiagram";
  version = "2.8.0";
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "graphics";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Se131GZE12wqdfN/V4id1pphUvteSrmMaKZ0+lqg1z8=";
  };
  nativeBuildInputs = [
    extra-cmake-modules
    qttools
  ];
  propagatedBuildInputs = [
    qtbase
    qtsvg
  ];
  meta = {
    description = "Libraries for creating business diagrams";
    license = lib.licenses.gpl2;
    platforms = qtbase.meta.platforms;
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
