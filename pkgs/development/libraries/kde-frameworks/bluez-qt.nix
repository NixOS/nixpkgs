{ kdeFramework, lib
, extra-cmake-modules
, qtdeclarative
}:

kdeFramework {
  name = "bluez-qt";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtdeclarative ];
  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace /lib/udev/rules.d "$out/lib/udev/rules.d"
  '';
}
