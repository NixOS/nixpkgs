{ kde, kdelibs, libspectre, analitza, R, pkgconfig, libqalculate, python }:
kde {

# TODO: R is not found

  buildInputs = [ kdelibs libspectre analitza R libqalculate python ];

  nativeBuildInputs = [ pkgconfig ];

  patches = [ ./commit-846cf02 ];

  meta = {
    description = "KDE Frontend to Mathematical Software";
  };
}
