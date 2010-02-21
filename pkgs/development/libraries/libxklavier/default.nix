args: with args;

stdenv.mkDerivation rec {
  name = "libxklavier-4.0";

  src = fetchurl {
    url = "mirror://sf/gswitchit/${name}.tar.bz2";
    sha256 = "210ed5803109a8cef3b2ab1195bc73fe3385a97a8749d01673e020642d8e5a71";
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
