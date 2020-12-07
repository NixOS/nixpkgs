{
  mkDerivation, lib, extra-cmake-modules, qtbase
, qtdeclarative, kconfig, kcoreaddons, ki18n, kio, kirigami2
, fetchpatch
}:

mkDerivation {
  name = "purpose";
  meta = { maintainers = [ lib.maintainers.bkchr ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  patches = [
    (fetchpatch {
      url = "https://github.com/KDE/purpose/commit/b3842a0941858792e997bb35b679a3fdf3ef54ca.patch";
      sha256 = "14brpryrrfrli1amk4flpnd03wr4zyycpiirndn9sjz0krqlgf3j";
    })
  ];
  buildInputs = [
    qtbase qtdeclarative kconfig kcoreaddons
    ki18n kio kirigami2
  ];
}
