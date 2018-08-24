{ stdenv, fetchurl }:
let
  # 0.2.1 broke the tests of pythonPackages.pyyaml 3.13
  version = "0.2.1";
in
stdenv.mkDerivation {
  name = "libyaml-${version}";

  src = fetchurl {
    url = "https://pyyaml.org/download/libyaml/yaml-${version}.tar.gz";
    sha256 = "1karpcfgacgppa82wm2drcfn2kb6q2wqfykf5nrhy20sci2i2a3q";
  };

  meta = with stdenv.lib; {
    homepage = https://pyyaml.org/;
    description = "A YAML 1.1 parser and emitter written in C";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
