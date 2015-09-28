{ mkDerivation, lib
, extra-cmake-modules
, qtdeclarative
}:

mkDerivation {
  name = "bluez-qt";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtdeclarative ];
  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace /lib/udev/rules.d "$out/lib/udev/rules.d"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
