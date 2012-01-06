{ kde, kdelibs, libarchive, xz, bzip2, kde_baseapps }:

kde {
  buildInputs = [ kdelibs kde_baseapps libarchive xz bzip2 ];

  meta = {
    description = "KDE Archiving Tool";
  };
}
