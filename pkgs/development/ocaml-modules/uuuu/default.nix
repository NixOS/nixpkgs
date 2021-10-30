{ angstrom
, buildDunePackage
, fetchzip
, findlib
, lib
, menhir
, ocaml
, re
}:

buildDunePackage rec {
  pname = "uuuu";
  version = "0.2.0";

  src = fetchzip {
    url = "https://github.com/mirage/uuuu/releases/download/v${version}/uuuu-v${version}.tbz";
    sha256 = "0457qcxvakbbc56frsh8a5v4y4l0raj9p4zz7jx3brn9255j1mw3";
  };

  postPatch = ''
    substituteInPlace src/dune --replace 'ocaml} ' \
      'ocaml} -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib '
  '';

  useDune2 = true;

  nativeBuildInputs = [ menhir ];

  buildInputs = [ angstrom ];

  checkInputs = [ re ];
  doCheck = true;

  meta = {
    description = "A library to normalize an ISO-8859 input to Unicode code-point";
    license = lib.licenses.mit;
    homepage = "https://github.com/mirage/uuuu";
    maintainers = with lib.maintainers; [ superherointj ];
  };
}
