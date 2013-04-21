{ kde, kdelibs, libkipi }:

kde {
  buildInputs = [ kdelibs libkipi ];

  meta = {
    description = "KDE screenshot utility";
    license = "GPLv2";
  };
}
