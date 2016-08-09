{ kdeFramework, lib
, ecm
, qtdeclarative
}:

kdeFramework {
  name = "bluez-qt";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ qtdeclarative ];
  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace /lib/udev/rules.d "$out/lib/udev/rules.d"
  '';
}
