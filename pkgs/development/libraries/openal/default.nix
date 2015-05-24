{ stdenv, fetchurl, alsaLib, cmake }:

let version = "1.16.0"; in
stdenv.mkDerivation rec {
  name = "openal-${version}";

  src = fetchurl {
    url = "http://kcat.strangesoft.net/openal-releases/openal-soft-${version}.tar.bz2";
    sha256 = "0pqdykdclycfnk66v166srjrry936y39d1dz9wl92qz27wqwsg9g";
  };

  buildInputs = [ cmake ] ++ stdenv.lib.optional (!stdenv.isDarwin) alsaLib;

  meta = {
    description = "Cross-platform 3D audio API";

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

    homepage = http://kcat.strangesoft.net/openal.html;
    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
