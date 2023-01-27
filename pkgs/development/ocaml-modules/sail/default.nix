{ lib
, fetchFromGitHub
, buildDunePackage

, base64
, omd
, menhir
, ott
, linenoise
, dune-site
, pprint
, makeWrapper
, lem
, z3
, linksem
, num
}:

buildDunePackage rec {
  pname = "sail";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "rems-project";
    repo = "sail";
    rev = version;
    hash = "sha256-eNdFOSzkniNvSCZeORRJ/IYAu+9P4HSouwmhd4BQLPk=";
  };

  duneVersion = "3";
  minimalOCamlVersion = "4.08";

  SAIL_DIR = "$out";

  nativeBuildInputs = [ base64 omd menhir ott linenoise dune-site pprint makeWrapper ];

  propagatedBuildInputs = [ lem z3 linksem num ];

  buildPhase = ''
    runHook preBuild
    rm -r aarch*  # Remove code derived from non-bsd2 arm spec
    rm -r snapshots  # Some of this might be derived from stuff in the aarch dir, it builds fine without it
    dune build --release ''${enableParallelBuild:+-j $NIX_BUILD_CORES}
    runHook postBuild
  '';
  checkPhase = ''
    runHook preCheck
    dune runtest ''${enableParallelBuild:+-j $NIX_BUILD_CORES}
    runHook postCheck
  '';
  installPhase = ''
    runHook preInstall
    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR
    runHook postInstall
  '';
  postInstall = ''
    mv $out/bin/sail $out/bin/.sail_wrapped
    makeWrapper $out/bin/.sail_wrapped $out/bin/sail --set SAIL_DIR $out/share/sail
  '';

  meta = with lib; {
    homepage = "https://github.com/rems-project/sail";
    description = "Sail is a language for describing the instruction-set architecture (ISA) semantics of processors";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd2;
  };
}
