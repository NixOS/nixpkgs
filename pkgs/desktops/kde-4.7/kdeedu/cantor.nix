{ kde, kdelibs, libspectre }:
kde {
  buildInputs = [ kdelibs libspectre ];

  meta = {
    description = "KDE Frontend to Mathematical Software";
  };
}
