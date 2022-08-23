{ lib, stdenv, buildDunePackage, fetchFromGitHub, ocplib-endian, cmdliner, afl-persistent
, calendar, fpath, pprint, uutf, uunf, uucp }:

buildDunePackage rec {
  pname = "crowbar";
  version = "0.2";

  useDune2 = true;

  src = fetchFromGitHub {
    owner  = "stedolan";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0wjfc9irvirfkic32ivvj6qb7r838w08b0d3vmngigbjpjyc9b14";
  };

  minimalOCamlVersion = "4.08";

  # Fix tests with pprint ≥ 20220103
  patches = [ ./pprint.patch ];

  # disable xmldiff tests, so we don't need to package unmaintained and legacy pkgs
  postPatch = "rm -rf examples/xmldiff";

  propagatedBuildInputs = [ ocplib-endian cmdliner afl-persistent ];
  checkInputs = [ calendar fpath pprint uutf uunf uucp ];
  # uunf is broken on aarch64
  doCheck = !stdenv.isAarch64;

  meta = with lib; {
    description = "Property fuzzing for OCaml";
    homepage = "https://github.com/stedolan/crowbar";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}

