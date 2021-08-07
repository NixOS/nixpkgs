{ lib, fetchurl, buildDunePackage, ocaml
, alcotest
, astring, cmdliner, cppo, fmt, logs, ocaml-version, odoc, ocaml_lwt, re, result, csexp
, pandoc}:

buildDunePackage rec {
  pname = "mdx";
  version = "1.10.1";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/realworldocaml/mdx/releases/download/${version}/mdx-${version}.tbz";
    sha256 = "10d4sfv4qk9569kj46pcaw6cih40v6bkgd44lmsp7cyfhvl8pa9x";
  };

  nativeBuildInputs = [ cppo ];
  buildInputs = [ cmdliner ];
  propagatedBuildInputs = [ astring fmt logs result csexp ocaml-version odoc re ];
  checkInputs = [ alcotest ocaml_lwt pandoc ];

  doCheck = true;

  outputs = [ "bin" "lib" "out" ];

  installPhase = ''
    runHook preInstall
    dune install --prefix=$bin --libdir=$lib/lib/ocaml/${ocaml.version}/site-lib ${pname}
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/realworldocaml/mdx";
    description = "Executable OCaml code blocks inside markdown files";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.romildo ];
  };
}
