{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "orc-0.4.29";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/orc/${name}.tar.xz";
    sha256 = "1cisbbn69p9c8vikn0nin14q0zscby5m8cyvzxyw2pjb2kwh32ag";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev"; # compilation tools

  postInstall = ''
    sed "/^toolsdir=/ctoolsdir=$dev/bin" -i "$dev"/lib/pkgconfig/orc*.pc
  '';

  # i686   https://gitlab.freedesktop.org/gstreamer/orc/issues/18
  # armv7l https://gitlab.freedesktop.org/gstreamer/orc/issues/9
  doCheck = (!stdenv.hostPlatform.isi686 && !stdenv.hostPlatform.isAarch32);

  meta = with stdenv.lib; {
    description = "The Oil Runtime Compiler";
    homepage = https://gstreamer.freedesktop.org/projects/orc.html;
    # The source code implementing the Marsenne Twister algorithm is licensed
    # under the 3-clause BSD license. The rest is 2-clause BSD license.
    license = with licenses; [ bsd3 bsd2 ];
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
