{ mkDerivation, lib, fetchpatch, extra-cmake-modules, qtbase, qttools }:

mkDerivation {
  name = "kconfig";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.7.0" < 0;
  };
  patches = [
    # https://phabricator.kde.org/D22979
    (fetchpatch {
      url = "https://cgit.kde.org/kconfig.git/patch/?id=5d3e71b1d2ecd2cb2f910036e614ffdfc895aa22";
      sha256 = "0vzrwkv3l8dlr786l6h0hqq208i6i1fbnsifi5b36d3732fqbq89";
      name = "kconfig-D22979.patch";
    })
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
}
