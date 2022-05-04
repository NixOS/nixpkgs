{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "easy-format";
  version = "1.3.2";

  src = fetchurl {
    url = "https://github.com/ocaml-community/easy-format/releases/download/${version}/easy-format-${version}.tbz";
    sha256 = "sha256:09hrikx310pac2sb6jzaa7k6fmiznnmhdsqij1gawdymhawc4h1l";
  };

  doCheck = true;

  meta = with lib; {
    description = "A high-level and functional interface to the Format module of the OCaml standard library";
    homepage = "https://github.com/ocaml-community/easy-format";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
