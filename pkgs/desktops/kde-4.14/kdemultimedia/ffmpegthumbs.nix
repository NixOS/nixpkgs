{ kde, kdelibs, ffmpeg }:
kde {
  buildInputs = [ kdelibs ffmpeg ];
  meta = {
    description = "A video thumbnail generator for KDE file managers like Dolphin and Konqueror";
  };
}
