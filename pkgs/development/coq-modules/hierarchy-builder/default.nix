{ stdenv, fetchFromGitHub, which, coq, coq-elpi }:

let
  versions = {
      "0.9.1" =  {
        rev = "v0.9.1";
        sha256 = "00fibahkmvisr16ffaxfrc00gcijsv9rgk4v8ibmy1jv0iyk875b";
      };
  };
  version = x: versions.${x} // {version = x;};
  params = {
   "8.11" = version "0.9.1";
  };
  param = params.${coq.coq-version};
in

stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-hierarchy-builder-${param.version}";

  src = fetchFromGitHub {
    owner = "math-comp";
    repo = "hierarchy-builder";
    inherit (param) rev sha256;
  };

  propagatedBuildInputs = [ coq-elpi ];
  buildInputs = [ coq coq.ocaml coq.ocamlPackages.elpi ];

  installPhase = ''make -f Makefile.coq VFILES=structures.v COQLIB=$out/lib/coq/${coq.coq-version}/ install'';

  meta = {
    description = "Coq plugin embedding ELPI.";
    maintainers = [ stdenv.lib.maintainers.cohencyril ];
    license = stdenv.lib.licenses.lgpl21;
    inherit (coq.meta) platforms;
    inherit (src.meta) homepage;
  };

  passthru = {
    compatibleCoqVersions = stdenv.lib.flip builtins.hasAttr params;
  };
}
