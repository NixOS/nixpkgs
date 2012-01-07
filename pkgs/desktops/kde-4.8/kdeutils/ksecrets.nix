{ kde, kdelibs, qca2 }:

kde {
  buildInputs = [ kdelibs qca2 ];

  meta = {
    description = "KDE implementation of SecretsService";
  };
}
