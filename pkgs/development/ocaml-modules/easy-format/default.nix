{ lib, fetchurl, ocaml, buildDunePackage }:

let params =
  if lib.versionAtLeast ocaml.version "4.08" then {
    version = "1.3.3";
    sha256 = "sha256:05n4mm1yz33h9gw811ivjw7x4m26lpmf7kns9lza4v6227lwmz7a";
  } else {
    version = "1.3.2";
    sha256 = "sha256:09hrikx310pac2sb6jzaa7k6fmiznnmhdsqij1gawdymhawc4h1l";
  };
in

buildDunePackage rec {
  pname = "easy-format";
  inherit (params) version;

  src = fetchurl {
    url = "https://github.com/ocaml-community/easy-format/releases/download/${version}/easy-format-${version}.tbz";
    inherit (params) sha256;
  };

  doCheck = true;

  meta = with lib; {
    description = "A high-level and functional interface to the Format module of the OCaml standard library";
    homepage = "https://github.com/ocaml-community/easy-format";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
