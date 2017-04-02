{ kdeFramework, lib
, extra-cmake-modules
, qtbase, qtdeclarative
}:

kdeFramework {
  name = "bluez-qt";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtdeclarative ];
  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace /lib/udev/rules.d "$out/lib/udev/rules.d"
  '';
}
