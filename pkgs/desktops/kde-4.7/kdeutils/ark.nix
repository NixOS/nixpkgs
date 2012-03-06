{ kde, kdelibs, libarchive, bzip2, kde_baseapps }:

kde {
  buildInputs = [ kdelibs kde_baseapps libarchive bzip2 ];

  meta = {
    description = "KDE Archiving Tool";
  };
}
