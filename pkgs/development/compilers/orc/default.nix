{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "orc-0.4.28";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/orc/${name}.tar.xz";
    sha256 = "bfcd7c6563b05672386c4eedfc4c0d4a0a12b4b4775b74ec6deb88fc2bcd83ce";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev"; # compilation tools

  postInstall = ''
    sed "/^toolsdir=/ctoolsdir=$dev/bin" -i "$dev"/lib/pkgconfig/orc*.pc
  '';

  # https://bugzilla.gnome.org/show_bug.cgi?id=728129#c15
  doCheck = stdenv.hostPlatform.system != "i686-linux"; # not sure about cross-compiling

  meta = with stdenv.lib; {
    description = "The Oil Runtime Compiler";
    homepage = https://gstreamer.freedesktop.org/projects/orc.html;
    # The source code implementing the Marsenne Twister algorithm is licensed
    # under the 3-clause BSD license. The rest is 2-clause BSD license.
    license = with licenses; [ bsd3 bsd2 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.fuuzetsu ];
  };
}
