{
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
  uri,
  xmlm,
  omd,
  ezjsonm,
}:

buildDunePackage rec {
  version = "2.5.0";
  pname = "cow";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cow/releases/download/v${version}/cow-${version}.tbz";
    hash = "sha256-8rNK+5oWUbi91gXvdz/66YQu5+iXp0Co8wk0Isv6b9Y=";
  };

  propagatedBuildInputs = [
    xmlm
    uri
    ezjsonm
    omd
  ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = {
    description = "Caml on the Web";
    longDescription = ''
      Writing web-applications requires a lot of skills: HTML, XML, JSON and
      Markdown, to name but a few! This library provides OCaml combinators
      for these web formats.
    '';
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
