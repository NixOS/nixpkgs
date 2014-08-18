{ kde, kdelibs, kde_baseapps, stdenv }:

kde {

  buildInputs = [ kdelibs kde_baseapps ];

  meta = {
    description = "Konsole, the KDE terminal emulator";
    license = stdenv.lib.licenses.gpl2;
  };
}
