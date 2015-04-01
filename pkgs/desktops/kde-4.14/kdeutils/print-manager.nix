{ kde, kdelibs
, pythonPackages, cups, pyqt4, pykde4, pycups, system_config_printer }:

let s_c_p = system_config_printer.override { withGUI = false; }; in

kde rec {
  buildInputs = [ kdelibs pythonPackages.python pythonPackages.wrapPython
    ] ++ pythonPath;

  pythonPath = [ cups pyqt4 pykde4 pycups s_c_p ];

  # system-config-printer supplies some D-Bus policy that we need.
  propagatedUserEnvPkgs = [ s_c_p ];

  postInstall = "wrapPythonPrograms";

  meta = {
    description = "KDE printer manager";
    longDescription = "Applet to view current print jobs and configure new printers";
  };
}
