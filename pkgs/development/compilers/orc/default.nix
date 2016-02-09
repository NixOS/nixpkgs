{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "orc-0.4.24";

  src = fetchurl {
    url = "http://gstreamer.freedesktop.org/src/orc/${name}.tar.xz";
    sha256 = "16ykgdrgxr6pfpy931p979cs68klvwmk3ii1k0a00wr4nn9x931k";
  };

  outputs = [ "out" "doc" ];

  # building memcpy_speed.log
  # ../test-driver: line 107:  4495 Segmentation fault      "$@" > $log_file 2>&1
  # FAIL: memcpy_speed
  doCheck = false; # see https://bugzilla.gnome.org/show_bug.cgi?id=728129#c7

  meta = {
    description = "The Oil Runtime Compiler";
    homepage = "http://code.entropywave.com/orc/";
    # The source code implementing the Marsenne Twister algorithm is licensed
    # under the 3-clause BSD license. The rest is 2-clause BSD license.
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
