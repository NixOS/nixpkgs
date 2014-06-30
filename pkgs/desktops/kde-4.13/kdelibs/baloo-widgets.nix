{ kde, kdelibs, baloo, kfilemetadata }:

kde {

  buildInputs = [ kdelibs baloo kfilemetadata ];

  meta = {
    description = "Baloo Widgets";
    license = "GPLv2";
  };
}
