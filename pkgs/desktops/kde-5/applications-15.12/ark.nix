{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, karchive
, kconfig
, kcrash
, kdbusaddons
, ki18n
, kiconthemes
, khtml
, kio
, kservice
, kpty
, kwidgetsaddons
, libarchive
, p7zip
, unrar
, unzipNLS
, zip
}:

let PATH = lib.makeBinPath [
      p7zip unrar unzipNLS zip
    ];
in

kdeApp {
  name = "ark";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    karchive
    kconfig
    kcrash
    kdbusaddons
    kiconthemes
    kservice
    kpty
    kwidgetsaddons
    libarchive
  ];
  propagatedBuildInputs = [
    khtml
    ki18n
    kio
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/ark" \
        --prefix PATH : "${PATH}"
  '';
  meta = {
    license = with lib.licenses; [ gpl2 lgpl3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
