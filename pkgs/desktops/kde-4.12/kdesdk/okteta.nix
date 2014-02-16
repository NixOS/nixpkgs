{ kde, kdelibs, qca2 }:

kde {
  buildInputs = [ kdelibs qca2 ];

# TODO: Look what does -DBUILD_mobile add

  enableParallelBuilding = false;

  meta = {
    description = "KDE byte editor";
  };
}
