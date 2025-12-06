{
  angstrom,
  buildDunePackage,
  fetchurl,
  findlib,
  lib,
  ocaml,
  re,
}:

buildDunePackage rec {
  pname = "uuuu";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/mirage/uuuu/releases/download/v${version}/uuuu-${version}.tbz";
    sha256 = "sha256-5+GNk9s36ZocrAjuvlDIiQTq6WF9q0M8j3h/TakrGSg=";
  };

  postPatch = ''
    substituteInPlace src/dune --replace 'ocaml} ' \
      'ocaml} -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib '
  '';

  nativeBuildInputs = [ findlib ];

  buildInputs = [ angstrom ];

  checkInputs = [ re ];
  doCheck = true;

  duneVersion = "3";

  meta = {
    description = "Library to normalize an ISO-8859 input to Unicode code-point";
    homepage = "https://github.com/mirage/uuuu";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "uuuu.generate";
  };
}
