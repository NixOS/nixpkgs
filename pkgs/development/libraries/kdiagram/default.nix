{
  mkDerivation, fetchFromGitLab, lib,
  extra-cmake-modules, qttools,
  qtbase, qtsvg,
}:

mkDerivation rec {
  pname = "kdiagram";
  version = "2.7.0";
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "graphics";
    repo = pname;
    rev = "v${version}";
    sha256 = "NSBNHPr8JzBn3y3ivhL0RjiXjDuPwZsTTOeI22pq3vc=";
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
