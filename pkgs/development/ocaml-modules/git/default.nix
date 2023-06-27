{ stdenv, lib, fetchurl, buildDunePackage
, alcotest, mirage-crypto-rng, git-binary
, angstrom, astring, cstruct, decompress, digestif, encore, fmt, checkseum
, fpath, ke, logs, lwt, ocamlgraph, uri, rresult, base64, hxd
, result, bigstringaf, optint, mirage-flow, domain-name, emile
, mimic, carton, carton-lwt, carton-git, ipaddr, psq, crowbar, alcotest-lwt, cmdliner
}:

buildDunePackage rec {
  pname = "git";
  version = "3.13.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-git/releases/download/${version}/git-${version}.tbz";
    hash = "sha256-98w2Amze/B+YN/ENfSb0V8I2yyFUf8rSEOcUg1YbVdM=";
  };

  # remove changelog for the carton package
  postPatch = ''
    rm CHANGES.carton.md
  '';

  buildInputs = [
    base64
  ];
  propagatedBuildInputs = [
    angstrom astring checkseum cstruct decompress digestif encore fmt fpath
    ke logs lwt ocamlgraph uri rresult result bigstringaf optint mirage-flow
    domain-name emile mimic carton carton-lwt carton-git ipaddr psq hxd
  ];
  nativeCheckInputs = [
    git-binary
  ];
  checkInputs = [
    alcotest alcotest-lwt mirage-crypto-rng crowbar cmdliner
  ];
  doCheck = !stdenv.isAarch64;

  meta = {
    description = "Git format and protocol in pure OCaml";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sternenseemann vbgl ];
    homepage = "https://github.com/mirage/ocaml-git";
  };
}
