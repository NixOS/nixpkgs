args: with args;

stdenv.mkDerivation rec {
  name = "libxklavier-3.4";

  src = fetchurl {
    url = "mirror://sf/gswitchit/${name}.tar.gz";
    sha256 = "07pq74ygmnr3vgfp86dbjnqsp3v67fww6d3a1vqbif9wzbk70195";
  };

# TODO: enable xmodmap support, needs xmodmap DB
  propagatedBuildInputs = [libX11 xkeyboard_config libxml2 libICE glib libxkbfile];
  
  buildInputs = [pkgconfig];
  
  configureFlags = ''
    --with-xkb-base=${xkeyboard_config}/etc/X11/xkb
    --disable-xmodmap-support
  '';

  meta = {
    homepage = http://freedesktop.org/wiki/Software/LibXklavier;
  };
}
