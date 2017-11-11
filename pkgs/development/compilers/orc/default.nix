{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "orc-0.4.27";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/orc/${name}.tar.xz";
    sha256 = "14vbwdydwarcvswzf744jdjb3ibhv6k4j6hzdacfan41zic3xrai";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev"; # compilation tools

  postInstall = ''
    sed "/^toolsdir=/ctoolsdir=$dev/bin" -i "$dev"/lib/pkgconfig/orc*.pc
  '';

  # building memcpy_speed.log
  # ../test-driver: line 107:  4495 Segmentation fault      "$@" > $log_file 2>&1
  # FAIL: memcpy_speed
  doCheck = false; # see https://bugzilla.gnome.org/show_bug.cgi?id=728129#c7

  meta = with stdenv.lib; {
    description = "The Oil Runtime Compiler";
    homepage = http://code.entropywave.com/orc/;
    # The source code implementing the Marsenne Twister algorithm is licensed
    # under the 3-clause BSD license. The rest is 2-clause BSD license.
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.fuuzetsu ];
  };
}
