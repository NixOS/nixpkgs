{ kde, kdelibs, boost }:

kde {
  name = "strigi-analyzer-torrent";

  buildInputs = [ kdelibs boost ];

  #preConfigure = "mv -v kdenetwork-strigi-analyzers kfile-plugins";
}
