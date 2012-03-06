{ fetchsvn, stdenv, ant }:

stdenv.mkDerivation rec {
  name = "hydra-ant-logger-${version}";
  version = "2010.2";

  src = fetchsvn {
    url = https://svn.nixos.org/repos/nix/hydra-ant-logger/trunk;
    rev = 20396;
    sha256 = "1lp5zy80m4y2kq222q2x052ys5mlhgc7y4kxh2bl48744f1fkgyr";
  };

  buildInputs = [ ant ];

  buildPhase = ''
    ln -s ${ant}/lib/ant.jar lib/ant.jar
    ant 
  '';

  installPhase = '' 
    mkdir -p "$out/lib/java"
    cp -v *.jar "$out/lib/java"
  '';
}
