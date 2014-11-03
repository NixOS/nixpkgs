{ kde, kdelibs, taglib, libtunepimp }:
kde {

# TODO: opusfile

  buildInputs = [ kdelibs taglib libtunepimp ];
  meta = {
    description = "an audio jukebox application";
  };
}
