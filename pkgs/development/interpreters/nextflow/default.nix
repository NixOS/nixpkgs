{ lib
, stdenv
, fetchurl
, makeWrapper
, openjdk17
, wget
, which
, gnused
, gawk
, coreutils
, buildFHSUserEnv
}:
let
  nextflow = stdenv.mkDerivation rec {
    pname = "nextflow";
    version = "22.10.4";

    src = fetchurl {
      url = "https://github.com/nextflow-io/nextflow/releases/download/v${version}/nextflow-${version}-all";
      sha256 = "sha256-/uwLB4oQU1EvLCHN/JL2JPkgYsSaPBSiAea3RYrlrHE=";
    };

    dontUnpack = true;

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ openjdk17 wget which gnused gawk coreutils ];

    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/nextflow
      runHook postInstall
    '';
    postFixup = ''
      wrapProgram $out/bin/nextflow --prefix PATH : ${lib.makeBinPath buildInputs}
    '';
    meta = with lib; {
      description = "A DSL for data-driven computational pipelines";
      longDescription = ''
        Nextflow is a bioinformatics workflow manager that enables the development of portable and reproducible workflows.
        It supports deploying workflows on a variety of execution platforms including local, HPC schedulers, AWS Batch, Google Cloud Life Sciences, and Kubernetes.
        Additionally, it provides support for manage your workflow dependencies through built-in support for Conda, Docker, Singularity, and Modules.
      '';
      homepage = "https://www.nextflow.io/";
      changelog = "https://github.com/nextflow-io/nextflow/releases";
      license = licenses.asl20;
      maintainers = [ maintainers.Etjean maintainers.illustratedman-code maintainers.emiller88 maintainers.stianlagstad ];
      mainProgram = "nextflow";
      platforms = platforms.unix;
    };
  };

in
buildFHSUserEnv {
  name = "nextflow";
  targetPkgs = pkgs: [ nextflow ];
  runScript = "nextflow";
}
