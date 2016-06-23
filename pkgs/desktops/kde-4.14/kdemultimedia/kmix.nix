{ kde, kdelibs, libcanberra, libpulseaudio }:
kde {
  buildInputs = [ kdelibs libcanberra libpulseaudio ];
  meta = {
    description = "Sound mixer, an application to allow you to change the volume of your sound card";
  };
}
