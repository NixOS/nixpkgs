{ stdenv, lib, fetchurl, buildDunePackage
, alcotest, mirage-crypto-rng, git-binary
, angstrom, astring, cstruct, decompress, digestif, encore, fmt, checkseum
, ke, logs, lwt, ocamlgraph, uri, rresult, base64, hxd
, bigstringaf, optint, mirage-flow, domain-name, emile
, mimic, carton, carton-lwt, carton-git, ipaddr, psq, crowbar, alcotest-lwt, cmdliner
}:

buildDunePackage rec {
  pname = "git";
  version = "3.17.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-git/releases/download/${version}/git-${version}.tbz";
    hash = "sha256-7yANBBLtGlOFJdBQEpiJDguJPgIFKAlNajrhI1n9AmU=";
  };

  buildInputs = [
    base64
  ];
  propagatedBuildInputs = [
    angstrom astring checkseum cstruct decompress digestif encore fmt
    ke logs lwt ocamlgraph uri rresult bigstringaf optint mirage-flow
    domain-name emile mimic carton carton-lwt carton-git ipaddr psq hxd
  ];
  nativeCheckInputs = [
    git-binary
  ];
  checkInputs = [
    alcotest alcotest-lwt mirage-crypto-rng crowbar cmdliner
  ];
  doCheck = !stdenv.hostPlatform.isAarch64;

  meta = {
    description = "Git format and protocol in pure OCaml";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sternenseemann vbgl ];
    homepage = "https://github.com/mirage/ocaml-git";
  };
}
