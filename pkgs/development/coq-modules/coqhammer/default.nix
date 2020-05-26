{ stdenv, fetchFromGitHub, coq }:

let
  params = {
    "8.8" = {
      version = "1.1";
      sha256 = "0ms086wp4jmrzyglb8wymchzyflflk01nsfsk4r6qv8rrx81nx9h";
      buildInputs = [ coq.ocamlPackages.camlp5 ];
    };
    "8.9" = {
      version = "1.1.1";
      sha256 = "1knjmz4hr8vlp103j8n4fyb2lfxysnm512gh3m2kp85n6as6fvb9";
      buildInputs = [ coq.ocamlPackages.camlp5 ];
    };
    "8.10" = {
      version = "1.1.1";
      sha256 = "0b6r7bsygl1axbqybkhkr7zlwcd51ski5ql52994klrrxvjd58df";
    };
  };
  param = params.${coq.coq-version};
in

stdenv.mkDerivation rec {
  inherit (param) version;
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
    ocaml findlib
  ]) ++ (param.buildInputs or []);

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
