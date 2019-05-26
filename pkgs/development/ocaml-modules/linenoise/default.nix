{ stdenv, fetchFromGitHub, buildDunePackage, result }:

buildDunePackage rec {
  pname = "linenoise";
  version = "1.1.0";

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "fxfactorial";
    repo = "ocaml-${pname}";
    rev = "v${version}";
    sha256 = "1h6rqfgmhmd7p5z8yhk6zkbrk4yzw1v2fgwas2b7g3hqs6y0xj0q";
  };

  propagatedBuildInputs = [ result ];

  meta = {
    description = "OCaml bindings to linenoise";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
