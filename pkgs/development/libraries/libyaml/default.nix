{ stdenv, fetchurl }:
let
  version = "0.1.5";
in
stdenv.mkDerivation {
  name = "libyaml-${version}";

  src = fetchurl {
    url = "http://pyyaml.org/download/libyaml/yaml-${version}.tar.gz";
    sha256 = "1vrv5ly58bkmcyc049ad180f2m8iav6l9h3v8l2fqdmrny7yx1zs";
  };

  meta = with stdenv.lib; {
    homepage = http://pyyaml.org/;
    description = "A YAML 1.1 parser and emitter written in C";
    license = licenses.mit;
  };
}
