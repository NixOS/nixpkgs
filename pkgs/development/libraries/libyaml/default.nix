{ stdenv, fetchurl }:
let
  # 0.2.1 broke the tests of pythonPackages.pyyaml 3.13
  version = "0.1.7";
in
stdenv.mkDerivation {
  name = "libyaml-${version}";

  src = fetchurl {
    url = "https://pyyaml.org/download/libyaml/yaml-${version}.tar.gz";
    sha256 = "0a87931cx5m14a1x8rbjix3nz7agrcgndf4h392vm62a4rby9240";
  };

  meta = with stdenv.lib; {
    homepage = https://pyyaml.org/;
    description = "A YAML 1.1 parser and emitter written in C";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
