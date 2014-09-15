{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "orc-0.4.21";

  src = fetchurl {
    url = "http://gstreamer.freedesktop.org/src/orc/${name}.tar.xz";
    sha256 = "187wrnq0ficwjj4y3yqci5fxcdkiazfs6k5js26k5b26hipzmham";
  };

  doCheck = stdenv.is64bit; # see https://bugzilla.gnome.org/show_bug.cgi?id=728129#c7

  meta = {
    description = "The Oil Runtime Compiler";
    homepage = "http://code.entropywave.com/orc/";
    # The source code implementing the Marsenne Twister algorithm is licensed
    # under the 3-clause BSD license. The rest is 2-clause BSD license.
    license = stdenv.lib.licenses.bsd3;
    platform = stdenv.lib.platforms.linux;
  };
}
