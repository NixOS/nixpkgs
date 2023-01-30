{ lib, stdenv, buildDunePackage, fetchFromGitHub, ocplib-endian, cmdliner, afl-persistent
, calendar, fpath, pprint, uutf, uunf, uucp }:

buildDunePackage rec {
  pname = "crowbar";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner  = "stedolan";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-0jjwiOZ9Ut+dv5Iw4xNvf396WTehT1VClxY9VHicw4U=";
  };

  minimalOCamlVersion = "4.08";

  # disable xmldiff tests, so we don't need to package unmaintained and legacy pkgs
  postPatch = "rm -rf examples/xmldiff";

  propagatedBuildInputs = [ ocplib-endian cmdliner afl-persistent ];
  nativeCheckInputs = [ calendar fpath pprint uutf uunf uucp ];
  # uunf is broken on aarch64
  doCheck = !stdenv.isAarch64;

  meta = with lib; {
    description = "Property fuzzing for OCaml";
    homepage = "https://github.com/stedolan/crowbar";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}

