{ stdenv, fetchurl, alsaLib, cmake }:

let version = "1.5.304"; in
stdenv.mkDerivation rec {
  name = "openal-${version}";

  src = fetchurl {
    url = "http://connect.creativelabs.com/openal/Downloads/openal-soft-${version}.tar.bz2";
    sha256 = "0k26ycprmpynvfkqkqsbaahl6avn033z2c03sp21vhpqbyms50ks";
  };

  # FIXME: The `$out/bin/openal-info' executable doesn't have the
  # right RPATH, so it can't find `libopenal.so'.  This must be fixed
  # by tweaking the CMake crap.
  buildInputs = [ cmake alsaLib ];

  meta = {
    description = "OpenAL, a cross-platform 3D audio API";

    longDescription = ''
      OpenAL is a cross-platform 3D audio API appropriate for use with
      gaming applications and many other types of audio applications.

      The library models a collection of audio sources moving in a 3D
      space that are heard by a single listener somewhere in that
      space.  The basic OpenAL objects are a Listener, a Source, and a
      Buffer.  There can be a large number of Buffers, which contain
      audio data.  Each buffer can be attached to one or more Sources,
      which represent points in 3D space which are emitting audio.
      There is always one Listener object (per audio context), which
      represents the position where the sources are heard -- rendering
      is done from the perspective of the Listener.
    '';

    homepage = http://www.openal.org/;
    license = "GPLv2+";
  };
}
