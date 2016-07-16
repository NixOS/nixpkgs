{
  kdeApp, lib,

  extra-cmake-modules, kdoctools, makeQtWrapper,

  karchive, kconfig, kcrash, kdbusaddons, ki18n, kiconthemes, khtml, kio,
  kservice, kpty, kwidgetsaddons, libarchive,

  # Archive tools
  p7zip, unrar, unzipNLS, zip
}:

kdeApp {
  name = "ark";
  nativeBuildInputs = [
    extra-cmake-modules kdoctools makeQtWrapper
  ];
  propagatedBuildInputs = [
    khtml ki18n kio karchive kconfig kcrash kdbusaddons kiconthemes kservice
    kpty kwidgetsaddons libarchive
  ];
  postInstall =
    let
      PATH = lib.makeBinPath [
        p7zip unrar unzipNLS zip
      ];
    in ''
      wrapQtProgram "$out/bin/ark" \
          --prefix PATH : "${PATH}"
    '';
  meta = {
    license = with lib.licenses; [ gpl2 lgpl3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
