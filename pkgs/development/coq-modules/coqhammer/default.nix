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
      version = "1.2";
      sha256 = "1ir313mmkgp2c65wgw8c681a15clvri1wb1hyjqmj7ymx4shkl56";
    };
    "8.11" = {
      version = "1.2";
      sha256 = "1w317h7r5llyamzn1kqb8j6p5sxks2j8vq8wnpzrx01jqbyibxgy";
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
