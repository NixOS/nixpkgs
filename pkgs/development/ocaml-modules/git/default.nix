{ stdenv, lib, fetchurl, buildDunePackage
, alcotest, mtime, mirage-crypto-rng, tls, git-binary
, angstrom, astring, cstruct, decompress, digestif, encore, duff, fmt, checkseum
, fpath, ke, logs, lwt, ocamlgraph, uri, rresult, base64, hxd
, result, bigstringaf, optint, mirage-flow, domain-name, emile, bigarray-compat
, mimic, carton, carton-lwt, carton-git, ipaddr, psq, crowbar, alcotest-lwt
}:

buildDunePackage rec {
  pname = "git";
  version = "3.9.0";

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-git/releases/download/${version}/git-${version}.tbz";
    sha256 = "0qynk1s6gp9g23n2l7zc541s3lgfi628xyhlj0ka7l7qks42bymb";
  };

  # remove changelog for the carton package
  postPatch = ''
    rm CHANGES.carton.md
  '';

  buildInputs = [
    base64
  ];
  propagatedBuildInputs = [
    angstrom astring checkseum cstruct decompress digestif encore duff fmt fpath
    ke logs lwt ocamlgraph uri rresult result bigstringaf optint mirage-flow
    domain-name emile mimic carton carton-lwt carton-git ipaddr psq hxd bigarray-compat
  ];
  checkInputs = [
    alcotest alcotest-lwt mtime mirage-crypto-rng tls git-binary crowbar
  ];
  doCheck = !stdenv.isAarch64;

  meta = {
    description = "Git format and protocol in pure OCaml";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sternenseemann vbgl ];
    homepage = "https://github.com/mirage/ocaml-git";
  };
}
