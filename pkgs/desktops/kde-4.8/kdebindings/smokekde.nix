{ kde, kdelibs, smokeqt }:

kde {
  propagatedBuildInputs = [ kdelibs smokeqt ];

  meta = {
    description = "C++ parser used to generate language bindings for Qt/KDE";
    license = "GPLv2";
  };
}
