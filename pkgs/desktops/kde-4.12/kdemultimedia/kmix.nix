{ kde, kdelibs, libcanberra, pulseaudio }:
kde {
  buildInputs = [ kdelibs libcanberra pulseaudio ];
  meta = {
    description = "sound mixer, an application to allow you to change the volume of your sound card";
  };
}
