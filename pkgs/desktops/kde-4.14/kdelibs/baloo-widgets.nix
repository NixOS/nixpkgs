{ stdenv, kde, kdelibs, baloo, kfilemetadata, pkgconfig }:

kde {
  buildInputs = [ kdelibs baloo kfilemetadata ];
  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Baloo Widgets";
    license = stdenv.lib.licenses.gpl2;
  };
}
