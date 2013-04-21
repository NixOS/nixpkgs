{ kde, kdelibs, libspectre, analitza, rLang, pkgconfig, gfortran, libqalculate }:
kde {

  buildInputs = [ kdelibs libspectre analitza rLang gfortran libqalculate];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "KDE Frontend to Mathematical Software";
  };
}
