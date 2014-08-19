{ makeWrapper, kde, kdelibs, libarchive, bzip2, kde_baseapps, lzma, qjson
, unzip }:

kde {
  buildInputs = [
    makeWrapper kdelibs kde_baseapps libarchive bzip2 lzma qjson
  ];

  postInstall = ''
    wrapProgram $out/bin/ark \
      --prefix PATH ":" "${unzip}/bin"
  '';

  meta = {
    description = "KDE Archiving Tool";
  };
}
