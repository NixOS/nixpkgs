{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "miniball-${version}";
  version = "3.0";

  src = fetchurl {
    url = "https://www.inf.ethz.ch/personal/gaertner/miniball/Miniball.hpp";
    sha256 = "1piap5v8wqq0aachrq6j50qkr01gzpyndl6vf661vyykrfq0nnd2";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/include
    cp $src $out/include/miniball.hpp
  '';

  meta = {
    description = "Smallest Enclosing Balls of Points";
    homepage = https://www.inf.ethz.ch/personal/gaertner/miniball.html;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.erikryb ];
    platforms = stdenv.lib.platforms.unix;
  };
}
