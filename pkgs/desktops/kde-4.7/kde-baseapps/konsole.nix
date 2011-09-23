{ kde, kdelibs }:

kde {

  buildInputs = [ kdelibs ];

  meta = {
    description = "Konsole, the KDE terminal emulator";
    license = "GPLv2";
  };
}
