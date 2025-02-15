{ lib, mkCoqDerivation, coq, fetchFromGitHub, version ? null }:

let
  tactician-dummy =
    (with lib; mkCoqDerivation {
      inherit version;
      pname = "tactician-dummy";
      owner = "coq-tactician";
      defaultVersion = with versions; switch coq.coq-version [
        { case = "8.13"; out = "8.13"; }
      ] null;
      
      release."8.13".rev = "fd5f81959d069d074b0475699a08e34275ac2f67";
      release."8.13".sha256 = "sha256-nBTpREC2lwhbsW8u0aHvpXZejFQqr3L3WmIE6CgWbzo=";

      # postPatch = ''
      #   substituteInPlace Makefile.coq.local --replace \
      #     '$(if $(COQBIN),$(COQBIN),`coqc -where | xargs dirname | xargs dirname`/bin/)' \
      #     '$(out)/bin/'
      #   substituteInPlace Makefile.coq.local --replace 'g++' 'c++' --replace 'gcc' 'cc'
      # '';

      # configureFlags = [ "--use-opam" ];
      
      extraNativeBuildInputs = with coq.ocamlPackages; [ ocaml findlib zarith ];
      # propagatedBuildInputs = with coq.ocamlPackages; [ ocaml ocamlbuild ];

      preInstall = ''
        mkdir -p $out/bin
      '';

      extraInstallFlags = [ "BINDIR=$(out)/bin" ];

      mlPlugin = true;
      useDune2 = true;
      

      meta = {
        description = "A Seamless, Interactive Tactic Learner and Prover for Coq";
        homepage = "https://coq-tactician.github.io/";
        license = licenses.lgpl21;
        maintainers = [ maintainers.siraben ];
      };
    }).overrideAttrs (oA: {
      src = fetchFromGitHub {
        repo = "coq-tactician-dummy";
        owner = "coq-tactician";
        rev = "fd5f81959d069d074b0475699a08e34275ac2f67";
        sha256 = "sha256-nBTpREC2lwhbsW8u0aHvpXZejFQqr3L3WmIE6CgWbzo=";
      };
    });
in
(with lib; mkCoqDerivation {
  inherit version;
  pname = "tactician";
  owner = "coq-tactician";
  defaultVersion = with versions; switch coq.coq-version [
    { case = "8.13"; out = "8.13"; }
    { case = "8.12"; out = "8.12"; }
    { case = "8.11"; out = "8.11"; }
  ] null;
  release."8.13".sha256 = "sha256-xzWHcx2u+vn2w+pTfU0fzxrosgqgbUW9jR/X18WQJV0=";
  release."8.12".sha256 = "sha256:0krsm8qj9lgfbggxv2jhkb03vy2cz63qypnarnl31fdmpykchi4b";
  release."8.11".sha256 = "sha256:0krsm8qj9lgfbggxv2jhkb03vy2cz63qypnarnl31fdmpykchi4b";

  releaseRev = v: "1.0-beta1-${v}";

  # postPatch = ''
  #   substituteInPlace Makefile.coq.local --replace \
  #     '$(if $(COQBIN),$(COQBIN),`coqc -where | xargs dirname | xargs dirname`/bin/)' \
  #     '$(out)/bin/'
  #   substituteInPlace Makefile.coq.local --replace 'g++' 'c++' --replace 'gcc' 'cc'
  # '';

  configureFlags = [
    "--use-opam"
  ];

  propagatedBuildInputs = [ tactician-dummy ];
  
  extraNativeBuildInputs = with coq.ocamlPackages; [ ocaml findlib zarith ];
  # propagatedBuildInputs = with coq.ocamlPackages; [ ocaml ocamlbuild ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  # mlPlugin = true;
  useDune2 = true;
  

  meta = {
    description = "A Seamless, Interactive Tactic Learner and Prover for Coq";
    homepage = "https://coq-tactician.github.io/";
    license = licenses.lgpl21;
    maintainers = [ maintainers.siraben ];
  };
}).overrideAttrs (oA: {
  src = fetchFromGitHub {
    repo = "coq-tactician";
    owner = "coq-tactician";
    rev = "1.0-beta1-8.13";
    sha256 = "sha256-xzWHcx2u+vn2w+pTfU0fzxrosgqgbUW9jR/X18WQJV0=";
  };
})
