{ kde, kdelibs
, pythonPackages, cups, pyqt4, pykde4, pycups, system_config_printer }:

let s_c_p = system_config_printer.override { withGUI = false; }; in

kde rec {
  buildInputs = [ kdelibs pythonPackages.python pythonPackages.wrapPython
    ] ++ pythonPath;

  pythonPath = [ cups pyqt4 pykde4 pycups s_c_p ];

  passthru.propagatedUserEnvPackages = [ s_c_p ];

  postInstall =
    ''
      wrapPythonPrograms

      # "system-config-printer" supplies some D-Bus policy that we need.
      mkdir -p $out/nix-support
      echo ${s_c_p} > $out/nix-support/propagated-user-env-packages
    '';

  meta = {
    description = "KDE printer manager";
    longDescription = "Applet to view current print jobs and configure new printers";
  };
}
