{ kde, kdelibs, qca2, shared_mime_info }:

kde {
  buildInputs = [ kdelibs qca2 ];

  nativeBuildInputs = [ shared_mime_info ];

# TODO: Look what does -DBUILD_mobile add

  enableParallelBuilding = false;

  meta = {
    description = "KDE byte editor";
  };
}
