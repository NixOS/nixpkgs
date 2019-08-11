{ lib, stdenv, fetchFromGitHub, cmake, eigen, suitesparse }:

stdenv.mkDerivation rec {
  pname = "g2o";
  version = "unstable-2019-04-07";

  src = fetchFromGitHub {
    owner = "RainerKuemmerle";
    repo = pname;
    rev = "9b41a4ea5ade8e1250b9c1b279f3a9c098811b5a";
    sha256 = "1rgrz6zxiinrik3lgwgvsmlww1m2fnpjmvcx1mf62xi1s2ma5w2i";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ eigen suitesparse ];

  meta = {
    description = "A General Framework for Graph Optimization";
    homepage = "https://github.com/RainerKuemmerle/g2o";
    license = with lib.licenses; [ bsd3 lgpl3 gpl3 ];
    maintainers = with lib.maintainers; [ lopsided98 ];
    platforms = lib.platforms.all;
  };
}
