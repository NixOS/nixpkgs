{ kde, kdelibs, qca2 }:

kde {
  buildInputs = [ kdelibs qca2 ];

# TODO: Look what does -DBUILD_mobile add

  meta = {
    description = "KDE byte editor";
  };
}
