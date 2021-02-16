{ stdenv, lib, fetchurl, buildDunePackage
, alcotest, mtime, mirage-crypto-rng, tls, git-binary
, angstrom, astring, cstruct, decompress, digestif, encore, duff, fmt, checkseum
, fpath, ke, logs, lwt, ocamlgraph, uri, rresult
, result, bigstringaf, optint, mirage-flow, domain-name, emile
, mimic, carton, carton-lwt, carton-git, ipaddr, psq, crowbar, alcotest-lwt
}:

buildDunePackage rec {
  pname = "git";
  version = "3.2.0";

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-git/releases/download/${version}/git-${version}.tbz";
    sha256 = "14rq7h1n5v2n0507ycbac8sq21xnzhgirxmlmqv4j5k3aajdcj16";
  };

  propagatedBuildInputs = [
    angstrom astring checkseum cstruct decompress digestif encore duff fmt fpath
    ke logs lwt ocamlgraph uri rresult result bigstringaf optint mirage-flow
    domain-name emile mimic carton carton-lwt carton-git ipaddr psq
  ];
  checkInputs = [
    alcotest alcotest-lwt mtime mirage-crypto-rng tls git-binary crowbar
  ];
  doCheck = !stdenv.isAarch64;

  meta = {
    description = "Git format and protocol in pure OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/mirage/ocaml-git";
  };
}
