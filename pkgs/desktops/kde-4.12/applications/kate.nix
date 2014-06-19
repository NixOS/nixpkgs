{ kde, kdelibs, kactivities, qjson, pyqt4, sip, python, pykde4, stdenv }:

kde {

  buildInputs = [ kdelibs kactivities qjson pyqt4 sip python pykde4 ];

  meta = {
    description = "Kate, the KDE Advanced Text Editor, as well as KWrite";
    license = stdenv.lib.licenses.gpl2;
  };
}
