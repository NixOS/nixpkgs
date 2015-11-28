{ kde, kdelibs, taglib_1_9, libtunepimp }:
kde {

# TODO: opusfile

  buildInputs = [ kdelibs taglib_1_9 libtunepimp ];
  meta = {
    description = "an audio jukebox application";
  };
}
