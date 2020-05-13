{ stdenv, fetchFromGitHub, which, coq, coq-elpi }:

let
  versions = {
      "0.9.1+alpha1" =  {
        rev = "d399d644ba7845dd6648e92b81b16f8ba77d597a";
        sha256 = "0nbrbfpzv2cx9ik9v8hnfn5nk3mknj4308sq5pp3qsh81cfqzzry";
      };
  };
  version = x: versions.${x} // {version = x;};
  params = {
   "8.11" = version "0.9.1+alpha1";
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
