{ kde, kdelibs, libspectre, analitza, R, pkgconfig, libqalculate }:
kde {

# TODO: R is not found

  buildInputs = [ kdelibs libspectre analitza R libqalculate];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "KDE Frontend to Mathematical Software";
  };
}
