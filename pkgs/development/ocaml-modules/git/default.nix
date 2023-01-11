{ stdenv, lib, fetchurl, buildDunePackage
, alcotest, mirage-crypto-rng, git-binary
, angstrom, astring, cstruct, decompress, digestif, encore, fmt, checkseum
, fpath, ke, logs, lwt, ocamlgraph, uri, rresult, base64, hxd
, result, bigstringaf, optint, mirage-flow, domain-name, emile
, mimic, carton, carton-lwt, carton-git, ipaddr, psq, crowbar, alcotest-lwt, cmdliner
}:

buildDunePackage rec {
  pname = "git";
  version = "3.10.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-git/releases/download/${version}/git-${version}.tbz";
    sha256 = "sha256-plu69FIpyJcuZ8nJ3QnufLnDEjtcsoAd8czKHfzTkd8=";
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
  checkInputs = [
    alcotest alcotest-lwt mirage-crypto-rng git-binary crowbar cmdliner
  ];
  doCheck = !stdenv.isAarch64;

  meta = {
    description = "Git format and protocol in pure OCaml";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sternenseemann vbgl ];
    homepage = "https://github.com/mirage/ocaml-git";
  };
}
