{ fetchgit, stdenv, ant }:

stdenv.mkDerivation rec {
  name = "hydra-ant-logger-${version}";
  version = "2010.2";

  src = fetchgit {
    url = https://github.com/NixOS/hydra-ant-logger.git;
    rev = "dae3224f4ed42418d3492bdf5bee4f825819006f";
    sha256 = "01s7m6007rn9107rw5wcgna7i20x6p6kfzl4f79jrvpkjy6kz176";
  };

  buildInputs = [ ant ];

  buildPhase = "mkdir lib; ant";

  installPhase = ''
    mkdir -p $out/lib/java
    cp -v *.jar $out/lib/java
  '';
}
