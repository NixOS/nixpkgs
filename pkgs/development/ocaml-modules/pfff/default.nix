{ buildDunePackage
, lib
, fetchFromGitHub
, ocaml
, opam
, perl
, dune_2
, ocamlgraph
, yojson
, menhir
, grain_dypgen
, ppx_deriving
, ppx_hash
, ppxlib
, uutf
, uucp
, alcotest
, ansiterminal
, easy_logging
, easy_logging_yojson
}:

buildDunePackage rec {
  pname = "pfff";
  version = "2021-12-14";

  src = fetchFromGitHub {
    owner = "returntocorp";
    repo = "pfff";
    rev = "0a3be7857551b69c430dc081575f9daef8ac85a0";
    sha256 = "YA/BN6AFXLyeT3SxCixqtzKgd4LfrDNqw1IEEsHDs+c=";
  };

  nativeBuildInputs = [
    ocaml
    opam
    perl
    dune_2
    menhir
    grain_dypgen
  ];

  propagatedBuildInputs = [
    ocamlgraph
    yojson
    grain_dypgen
    ppx_deriving
    ppx_hash
    ppxlib
    uutf
    uucp
    alcotest
    ansiterminal
    easy_logging
    easy_logging_yojson
  ];

  useDune2 = true;
  strictDeps = true;

  postPatch = ''
    patchShebangs ./configure
  '';

  buildPhase = ''
    runHook preBuild
    dune build ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    dune runtest ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tools and APIs for program analysis, code visualization, refactoring";
    homepage = "https://github.com/returntocorp/pfff/wiki";
    license = licenses.lgpl21Only;
    maintainers = [ ];
    platforms = ocaml.meta.platforms or [];
  };
}
