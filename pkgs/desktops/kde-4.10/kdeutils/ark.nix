{ kde, kdelibs, libarchive, bzip2, kde_baseapps, lzma, qjson }:

kde {
  buildInputs = [ kdelibs kde_baseapps libarchive bzip2 lzma qjson ];

  meta = {
    description = "KDE Archiving Tool";
  };
}
