{ kde, kdelibs, kdebindings }:

kde {
  propagatedBuildInputs = [ kdelibs kdebindings.smokeqt ];

  meta = {
    description = "C++ parser used to generate language bindings for Qt/KDE";
    license = "GPLv2";
  };
}
