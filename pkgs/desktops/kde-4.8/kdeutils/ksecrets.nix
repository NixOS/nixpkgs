{ kde, kdelibs, qca2 }:

kde {
  buildInputs = [ kdelibs qca2 ];

  patches = [ ./ksecrets-ftbfs.patch ];

  meta = {
    description = "KDE implementation of SecretsService";
  };
}
