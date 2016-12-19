{ stdenv, kde, kdelibs, kactivities, qjson, pythonPackages, pykde4}:

kde {

  buildInputs = [ kdelibs kactivities qjson pythonPackages.pyqt4 pythonPackages.python pykde4 ];

  meta = {
    description = "Kate, the KDE Advanced Text Editor, as well as KWrite";
    license = stdenv.lib.licenses.gpl2;
  };
}
