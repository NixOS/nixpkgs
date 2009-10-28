{stdenv, fetchurl, pkgconfig, strategoPackages}:

stdenv.mkDerivation rec {
  name = "webdsl-9.7pre3056";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/71896/download/1/webdsl-9.7pre3056.tar.gz";
    sha256 = "3446b7e9dac27a9fd35541a57e961be5b74f2f9e3fb02dc14c86f945b47df045";
  };

  buildInputs = [
    pkgconfig strategoPackages.aterm strategoPackages.sdf
    strategoPackages.strategoxt strategoPackages.javafront
  ];

  meta = {
    homepage = http://webdsl.org/;
    description = "A domain-specific language for developing dynamic web applications with a rich data model";
  };
}
