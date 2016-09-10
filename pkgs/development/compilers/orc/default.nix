{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "orc-0.4.26";

  src = fetchurl {
    url = "http://gstreamer.freedesktop.org/src/orc/${name}.tar.xz";
    sha256 = "0jd69ynvr3k70mlxxgbsk047l1rd63m1wkj3qdcq7644xy0gllkx";
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
    homepage = "http://code.entropywave.com/orc/";
    # The source code implementing the Marsenne Twister algorithm is licensed
    # under the 3-clause BSD license. The rest is 2-clause BSD license.
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.fuuzetsu ];
  };
}
