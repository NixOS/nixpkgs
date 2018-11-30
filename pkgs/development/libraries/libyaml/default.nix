{ stdenv, fetchurl, fetchpatch }:

let

  version = "0.2.1";

  # https://github.com/yaml/pyyaml/issues/214
  p1 = fetchpatch {
         url = https://github.com/yaml/libyaml/commit/8ee83c0da22fe9aa7dea667be8f899a7e32ffb83.patch;
         sha256 = "00jh39zww6s4gyhxfmlxwb6lz90nl3p51k5h1qm6z3ymik5vljmz";
       };
  p2 = fetchpatch {
         url = https://github.com/yaml/libyaml/commit/56f4b17221868593d6903ee58d6d679b690cf4df.patch;
         sha256 = "0najcay1y4kgfpsidj7dnyafnwjbav5jyawhyv215zl9gg3386n0";
       };

in

stdenv.mkDerivation {
  name = "libyaml-${version}";

  src = fetchurl {
    url = "https://pyyaml.org/download/libyaml/yaml-${version}.tar.gz";
    sha256 = "1karpcfgacgppa82wm2drcfn2kb6q2wqfykf5nrhy20sci2i2a3q";
  };

  patches = [ p1 p2 ];  # remove when the next release comes out

  meta = with stdenv.lib; {
    homepage = https://pyyaml.org/;
    description = "A YAML 1.1 parser and emitter written in C";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
