{ kde, cmake, kdelibs, qt4, perl, automoc4
, python, sip, pyqt4, pycups, rhpl, system_config_printer, kdebindings,
  pythonDBus, makeWrapper }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 python sip pyqt4 pycups rhpl
    system_config_printer kdebindings makeWrapper pythonDBus ];

  postInstall="wrapProgram $out/bin/printer-applet --set PYTHONPATH $PYTHONPATH";

  meta = {
    description = "KDE printer applet";
    longDescription = "Applet to view current print jobs and configure new printers";
    kde = {
      name = "printer-applet";
      module = "kdeutils";
      version = "1.5";
      release = "4.5.1";
    };
  };
}
