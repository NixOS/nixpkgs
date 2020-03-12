{ stdenv, fetchFromGitHub, coq }:

let
  params = {
    "8.8" = {
      sha256 = "0ms086wp4jmrzyglb8wymchzyflflk01nsfsk4r6qv8rrx81nx9h";
    };
    "8.9" = {
      sha256 = "0hmqwsry8ldg4g4hhwg4b84dgzibpdrg1wwsajhlyqfx3fb3n3b5";
    };
  };
  param = params.${coq.coq-version};
in

stdenv.mkDerivation rec {
  version = "1.1";
  name = "coq${coq.coq-version}-coqhammer-${version}";

  src = fetchFromGitHub {
    owner = "lukaszcz";
    repo = "coqhammer";
    rev = "v${version}-coq${coq.coq-version}";
    inherit (param) sha256;
  };

  postPatch = ''
    substituteInPlace Makefile.coq.local --replace \
      '$(if $(COQBIN),$(COQBIN),`coqc -where | xargs dirname | xargs dirname`/bin/)' \
      '$(out)/bin/'
    substituteInPlace Makefile.coq.local --replace 'g++' 'c++' --replace 'gcc' 'cc'
  '';

  buildInputs = [ coq ] ++ (with coq.ocamlPackages; [
    ocaml findlib camlp5
  ]);

  preInstall = ''
    mkdir -p $out/bin
  '';

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  meta = {
    homepage = "http://cl-informatik.uibk.ac.at/cek/coqhammer/";
    description = "Automation for Dependent Type Theory";
    license = stdenv.lib.licenses.lgpl21;
    inherit (coq.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v params;
  };

}
