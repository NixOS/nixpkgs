{stdenv, fetchurl, SDL, mesa, erlang}:

stdenv.mkDerivation rec {
  name = "esdl-1.2";

  src = fetchurl {
    url = "mirror://sourceforge/esdl/${name}.src.tar.gz";
    sha256 = "0zbnwhy2diivrrs55n96y3sfnbs6lsgz91xjaq15sfi858k9ha29";
  };

  buildInputs = [ erlang ];
  propagatedBuildInputs = [ SDL mesa ];

  preBuild = ''
    export makeFlags="INSTALLDIR=$out/lib/erlang/addons/${name}";
  '';

  meta = {
    homepage = http://esdl.sourceforge.net/;
    description = "Erlang binding to SDL that includes a binding to OpenGL";
    license = "BSD";
  };
}
