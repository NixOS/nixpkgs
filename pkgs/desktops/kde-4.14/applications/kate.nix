{ stdenv, kde, kdelibs, kactivities, qjson, pyqt4, python, pykde4}:

kde {

  buildInputs = [ kdelibs kactivities qjson pyqt4 python pykde4 ];

  meta = {
    description = "Kate, the KDE Advanced Text Editor, as well as KWrite";
    license = stdenv.lib.licenses.gpl2;
  };
}
