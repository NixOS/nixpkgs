{
  mkDerivation, lib, fetchpatch,
  extra-cmake-modules,
  kconfig, kwidgetsaddons, qtbase, qttools
}:

mkDerivation {
  name = "kcompletion";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  patches = [
    # https://mail.kde.org/pipermail/distributions/2021-January/000928.html
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/kcompletion/commit/7acda936f06193e9fc85ae5cf9ccc8d65971f657.patch";
      sha256 = "150ff506rhr5pin5363ks222vhv8qd77y5s5nyylcbdjry3ljd3n";
    })
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kconfig kwidgetsaddons qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
