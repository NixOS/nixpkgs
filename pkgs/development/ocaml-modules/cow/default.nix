{ lib, fetchurl, buildDunePackage, ocaml, alcotest
, uri, xmlm, omd, ezjsonm }:

buildDunePackage rec {
  useDune2 = true;
  minimumOCamlVersion = "4.02.3";

  version = "2.4.0";
  pname = "cow";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cow/releases/download/v${version}/cow-v${version}.tbz";
    sha256 = "1x77lwpskda4zyikwxh500xjn90pgdwz6jm7ca7f36pyav4vl6zx";
  };

  propagatedBuildInputs = [ xmlm uri ezjsonm omd ];
  nativeCheckInputs = [ alcotest ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = with lib; {
    description = "Caml on the Web";
    longDescription = ''
      Writing web-applications requires a lot of skills: HTML, XML, JSON and
      Markdown, to name but a few! This library provides OCaml combinators
      for these web formats.
    '';
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}
