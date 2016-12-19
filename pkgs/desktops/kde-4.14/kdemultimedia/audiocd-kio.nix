{ kde, kdelibs, libkcompactdisc, cdparanoia, libkcddb, libvorbis, flac, lame }:
kde {
  buildInputs = [ kdelibs libkcompactdisc cdparanoia libkcddb libvorbis flac lame ];
  meta = {
    description = "Transparent audio CD access for applications using the KDE Platform";
  };
}
