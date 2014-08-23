{ kde, kdelibs }:

kde {
  name = "kde-emotion-icons";

  buildInputs = [ kdelibs ];

  meta = {
    description = "Additional KDE emotion icons (smiles)";
  };
}
