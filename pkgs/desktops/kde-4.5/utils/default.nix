{ kdePackage, cmake, qt4, perl, gmp, python, libzip, libarchive, xz
, sip, pyqt4, pycups, rhpl, system_config_printer, qjson, shared_mime_info
, kdebase_workspace
, kdelibs, kdepimlibs, kdebase, kdebindings, automoc4, qimageblitz, qca2}:

kdePackage {
  pn = "kdeutils";
  v = "4.5.0";
  
  postPatch = ''
    cp -vn ${qjson}/share/apps/cmake/modules/FindQJSON.cmake cmake/modules
    sed -e "s@/usr\(/share/system-config-printer\)@${system_config_printer}\1@" -i \
      printer-applet/cmake-modules/FindSystemConfigPrinter.py \
      printer-applet/printer-applet.py
    sed -i -e "s|import cupshelpers.ppds, cupshelpers.cupshelpers|import ppds, cupshelpers|" printer-applet/cmake-modules/FindSystemConfigPrinter.py
    '';

  buildInputs = [ cmake qt4 perl gmp python libzip libarchive xz sip pyqt4
    pycups rhpl system_config_printer kdelibs kdepimlibs kdebase kdebindings
    automoc4 qimageblitz qca2 qjson shared_mime_info kdebase_workspace ];

  patches = [ ./log-feature.diff ];
                  
  meta = {
    description = "KDE Utilities";
    license = "GPL";
  };
}
