{ kdePackage, cmake, qt4, perl, gmp, python, libzip, libarchive, xz
, sip, pyqt4, pycups, rhpl, system_config_printer, qjson, shared_mime_info
, kdelibs, kdepimlibs, kdebase, kdebindings, automoc4, qimageblitz, qca2}:

kdePackage {
  pn = "kdeutils";
  v = "4.5.0";
  
  inherit system_config_printer;
  preConfigure = ''
    sed -e "s@/usr\(/share/system-config-printer\)@${system_config_printer}\1@" -i \
      printer-applet/cmake-modules/FindSystemConfigPrinter.py \
      printer-applet/printer-applet.py
    sed -i -e "s|import cupshelpers.ppds, cupshelpers.cupshelpers|import ppds, cupshelpers|" printer-applet/cmake-modules/FindSystemConfigPrinter.py
    '';

  cmakeFlags = "-DCMAKE_MODULE_PATH=${qjson}/share/apps/cmake/modules";
  patches = [ ./cmake-module-path.diff ];
  
  buildInputs = [ cmake qt4 perl gmp python libzip libarchive xz sip pyqt4
    pycups rhpl system_config_printer kdelibs kdepimlibs kdebase kdebindings
    automoc4 qimageblitz qca2 qjson shared_mime_info ];
                  
  meta = {
    description = "KDE Utilities";
    license = "GPL";
    homepage = http://www.kde.org;
    inherit (kdelibs.meta) maintainers platforms;
  };
}
