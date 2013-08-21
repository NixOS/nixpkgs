{ kde, kdelibs, libspectre, analitza, R, pkgconfig, gfortran, libqalculate }:
kde {

  buildInputs = [ kdelibs libspectre analitza R gfortran libqalculate];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "KDE Frontend to Mathematical Software";
  };
}
