{ stdenv, fetchurl, fetchpatch }:
let
  version = "0.1.6";
in
stdenv.mkDerivation {
  name = "libyaml-${version}";

  src = fetchurl {
    url = "http://pyyaml.org/download/libyaml/yaml-${version}.tar.gz";
    sha256 = "0j9731s5zjb8mjx7wzf6vh7bsqi38ay564x6s9nri2nh9cdrg9kx";
  };

  patches = [(fetchpatch {
    name = "CVE-2014-9130.diff";
    url = "http://bitbucket.org/xi/libyaml/commits/2b915675/raw/";
    sha256 = "1vrkga2wk060wccg61c2mj5prcyv181qikgdfi1z4hz8ygmpvl04";
  })];

  meta = with stdenv.lib; {
    homepage = http://pyyaml.org/;
    description = "A YAML 1.1 parser and emitter written in C";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
