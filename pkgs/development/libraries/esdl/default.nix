{stdenv, fetchurl, SDL, mesa, rebar, erlang}:

stdenv.mkDerivation rec {
  name = "esdl-1.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/esdl/${name}.src.tgz";
    sha256 = "0f5ad519600qarsa2anmnaxh6b7djzx1dnwxzi4l36pxsq896y01";
  };

  buildInputs = [ erlang rebar ];
  propagatedBuildInputs = [ SDL mesa ];

  buildPhase = ''
    rebar compile
  '';

  # 'cp' line taken from Arch recipe
  # https://projects.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/erlang-sdl
  installPhase = ''
    DIR=$out/lib/erlang/lib/${name}
    mkdir -p $DIR
    cp -ruv c_src doc ebin include priv src $DIR
  '';

  meta = {
    homepage = http://esdl.sourceforge.net/;
    description = "Erlang binding to SDL that includes a binding to OpenGL";
    license = "BSD";
    platforms = stdenv.lib.platforms.linux;
  };
}
