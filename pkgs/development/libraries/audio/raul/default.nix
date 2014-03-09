{ stdenv, fetchurl, boost, gtk, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "raul-${version}";
  version = "0.8.0";

  src = fetchurl {
    url = "http://download.drobilla.net/${name}.tar.bz2";
    sha256 = "09ms40xc1x6qli6lxkwn5ibqh62nl9w7dq0b6jh1q2zvnrxwsd8b";
  };

  buildInputs = [ boost gtk pkgconfig python ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    description = "A C++ utility library primarily aimed at audio/musical applications";
    homepage = http://drobilla.net/software/raul;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
  };
}
