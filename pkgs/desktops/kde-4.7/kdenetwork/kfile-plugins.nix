{ kde, kdelibs, boost }:

kde {
  name = "strigi-analyzer-torrent";

  buildInputs = [ kdelibs boost ];

  preConfigure = "mv -v strigi-analyzer kfile-plugins";

  patches = [ ./kdenetwork.patch ];
}
