{ kde, kdelibs, ffmpeg }:
kde {
  buildInputs = [ kdelibs ffmpeg ];
  meta = {
    description = "a video thumbnail generator for KDE file managers like Dolphin and Konqueror";
  };
}
