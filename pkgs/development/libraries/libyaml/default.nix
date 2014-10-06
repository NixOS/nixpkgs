{ stdenv, fetchurl }:
let
  version = "0.1.6";
in
stdenv.mkDerivation {
  name = "libyaml-${version}";

  src = fetchurl {
    url = "http://pyyaml.org/download/libyaml/yaml-${version}.tar.gz";
    sha256 = "0j9731s5zjb8mjx7wzf6vh7bsqi38ay564x6s9nri2nh9cdrg9kx";
  };

  meta = with stdenv.lib; {
    homepage = http://pyyaml.org/;
    description = "A YAML 1.1 parser and emitter written in C";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
