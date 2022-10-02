{
  lib, mkDerivation, extra-cmake-modules, kdoctools,
  kcmutils, kconfig, kdesu, ki18n, kiconthemes, kinit, kio, kwindowsystem,
  qtsvg, qtx11extras, kactivities, plasma-workspace
}:

mkDerivation {
  pname = "kde-cli-tools";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcmutils kconfig kdesu ki18n kiconthemes kinit kio kwindowsystem qtsvg
    qtx11extras kactivities plasma-workspace
  ];
  postInstall = ''
    # install a symlink in bin so that kdesu can eventually be found in PATH
    mkdir -p $out/bin
    ln -s $out/libexec/kf5/kdesu $out/bin
  '';
  dontWrapQtApps = true;
  preFixup = ''
    for program in $out/bin/*; do
      wrapQtApp $program
    done

    # kdesu looks for kdeinit5 in PATH
    wrapQtApp $out/libexec/kf5/kdesu --suffix PATH : ${lib.getBin kinit}/bin
  '';
}
