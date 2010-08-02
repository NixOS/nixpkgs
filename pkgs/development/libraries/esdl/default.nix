{stdenv, fetchurl, SDL, mesa, erlang}:

stdenv.mkDerivation rec {
  name = "esdl-1.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/esdl/${name}.src.tar.gz";
    sha256 = "0zc7cmr44v10sb593dismdm5qc2v7sm3z9yh22g4r9g6asbg5z0n";
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
