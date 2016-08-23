{ kde, kdelibs
, pythonPackages, cups, pykde4, system-config-printer }:

let s_c_p = system-config-printer.override { withGUI = false; }; in

kde rec {
  buildInputs = [ kdelibs pythonPackages.python pythonPackages.wrapPython
    ] ++ pythonPath;

  pythonPath = [ cups pythonPackages.pyqt4 pykde4 pythonPackages.pycups s_c_p ];

  # system-config-printer supplies some D-Bus policy that we need.
  propagatedUserEnvPkgs = [ s_c_p ];

  postInstall = "wrapPythonPrograms";

  meta = {
    description = "KDE printer manager";
    longDescription = "Applet to view current print jobs and configure new printers";
  };
}
