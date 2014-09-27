{ stdenv, kde, kdelibs, htmlTidy, kactivities
, nepomuk_core, nepomuk_widgets, libXt }:

kde {
  buildInputs = [ kdelibs nepomuk_core nepomuk_widgets htmlTidy kactivities libXt ];

  meta = {
    description = "Base KDE applications, including the Dolphin file manager and Konqueror web browser";
    license = stdenv.lib.licenses.gpl2;
  };
}
