args: with args;

stdenv.mkDerivation rec {
  name = "libxklavier-3.9";

  src = fetchurl {
    url = "mirror://sf/gswitchit/${name}.tar.bz2";
    sha256 = "462a4e427f201a23de194f824dce70c84867464956f2f6c8dd4a5e07f1f4a554";
  };

# TODO: enable xmodmap support, needs xmodmap DB
  propagatedBuildInputs = [libX11 libXi xkeyboard_config libxml2 libICE glib libxkbfile isocodes];
  
  buildInputs = [pkgconfig];
  
  configureFlags = ''
    --with-xkb-base=${xkeyboard_config}/etc/X11/xkb
    --disable-xmodmap-support
  '';

  meta = {
    homepage = http://freedesktop.org/wiki/Software/LibXklavier;
  };
}
