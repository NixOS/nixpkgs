{ stdenv, fetchurl, autoconf, autogen, automake, gettext, libX11
, mesa, pkgconfig, python, utilmacros
}:

stdenv.mkDerivation rec {
  name = "epoxy-${version}";
  version = "1.2";

  src = fetchurl {
    url = "https://github.com/anholt/libepoxy/archive/v${version}.tar.gz";
    sha256 = "1xp8g6b7xlbym2rj4vkbl6xpb7ijq7glpv656mc7k9b01x22ihs2";
  };

  buildInputs = [
    autoconf autogen automake gettext libX11 mesa pkgconfig python
    utilmacros
  ];

  configureScript = ''
    ./autogen.sh --prefix="$out"
  '';

  meta = with stdenv.lib; {
    description = "A library for handling OpenGL function pointer management";
    homepage = https://github.com/anholt/libepoxy;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
