{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  dune-build-info,
  bos,
}:
let
  author = "avsm";
  pname = "ocaml-print-intf";
  version = "1.2.0";
in
buildDunePackage rec {
  inherit pname version;
  useDune2 = true;

  src = fetchFromGitHub {
    owner = author;
    repo = pname;
    rev = "v${version}";
    sha256 = "0hw4gl7irarcywibdjqxmrga8f7yj52wgy7sc7n0wyy74jzxb8np";
  };

  buildInputs = [
    dune-build-info
    bos
  ];

  meta = {
    description = "Pretty print an OCaml cmi/cmt/cmti file in human-readable OCaml signature form";
    homepage = "https://github.com/${author}/${pname}";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.nerdypepper ];
  };
}
