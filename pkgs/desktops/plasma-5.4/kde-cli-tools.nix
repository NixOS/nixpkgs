{ plasmaPackage, extra-cmake-modules, kcmutils, kconfig
, kdelibs4support, kdesu, kdoctools, ki18n, kiconthemes
, kwindowsystem, makeKDEWrapper, qtsvg, qtx11extras
}:

plasmaPackage {
  name = "kde-cli-tools";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeKDEWrapper ];
  buildInputs = [
    kcmutils kconfig kdesu kiconthemes
  ];
  propagatedBuildInputs = [
    kdelibs4support ki18n kwindowsystem qtsvg qtx11extras
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kmimetypefinder5"
    wrapKDEProgram "$out/bin/ksvgtopng5"
    wrapKDEProgram "$out/bin/ktraderclient5"
    wrapKDEProgram "$out/bin/kioclient5"
    wrapKDEProgram "$out/bin/kdecp5"
    wrapKDEProgram "$out/bin/keditfiletype5"
    wrapKDEProgram "$out/bin/kcmshell5"
    wrapKDEProgram "$out/bin/kdemv5"
    wrapKDEProgram "$out/bin/kstart5"
    wrapKDEProgram "$out/bin/kde-open5"
  '';
}
