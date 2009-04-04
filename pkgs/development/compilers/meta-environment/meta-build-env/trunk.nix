{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "meta-build-env-trunk";
  src = fetchurl {
    url = http://hydra.nixos.org/build/9794/download/1/meta-build-env-0.1.tar.gz ;
    sha256 = "1337000664114df83025e165b5af202a153654ea3226a347dc150769260c7a7b" ;
  };
}
