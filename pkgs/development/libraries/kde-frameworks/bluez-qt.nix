{ mkDerivation
, extra-cmake-modules
, qtbase, qtdeclarative
}:

mkDerivation {
  name = "bluez-qt";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtdeclarative ];
  propagatedBuildInputs = [ qtbase ];
  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace /lib/udev/rules.d "$bin/lib/udev/rules.d"
  '';
}
