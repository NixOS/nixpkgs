{ fetchsvn, stdenv, ant }:

stdenv.mkDerivation rec {
  name = "hydra-ant-logger-${version}";
  version = "2010.1";

  src = fetchsvn {
    url = https://svn.nixos.org/repos/nix/hydra-ant-logger/trunk;
    rev = 20331;
    sha256 = "1plpdca9izf95kq2v0wh56ddk9bdwxk940nf9z32rhc1633wpk8c";
  };

  buildInputs = [ ant ];

  buildPhase = ''
    ln -s ${ant}/lib/ant.jar lib/ant.jar
    ant 
  '';

  installPhase = '' 
    ensureDir "$out/lib/java"
    cp -v *.jar "$out/lib/java"
  '';
}
