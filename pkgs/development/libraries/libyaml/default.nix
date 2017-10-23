{ stdenv, fetchurl, fetchpatch }:
let
  version = "0.1.7";
in
stdenv.mkDerivation {
  name = "libyaml-${version}";

  src = fetchurl {
    url = "http://pyyaml.org/download/libyaml/yaml-${version}.tar.gz";
    sha256 = "0a87931cx5m14a1x8rbjix3nz7agrcgndf4h392vm62a4rby9240";
  };

  meta = with stdenv.lib; {
    homepage = http://pyyaml.org/;
    description = "A YAML 1.1 parser and emitter written in C";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
