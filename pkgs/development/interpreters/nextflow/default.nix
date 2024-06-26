{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  openjdk17,
  wget,
  which,
  gnused,
  gawk,
  coreutils,
  buildFHSEnv,
}:

let
  nextflow = stdenv.mkDerivation rec {
    pname = "nextflow";
    version = "22.10.6";

    src = fetchurl {
      url = "https://github.com/nextflow-io/nextflow/releases/download/v${version}/nextflow-${version}-all";
      hash = "sha256-zeYsKxWRnzr0W6CD+yjoAXwCN/AbN5P4HhH1oftnrjY=";
    };

    nativeBuildInputs = [
      makeWrapper
      openjdk17
      wget
      which
      gnused
      gawk
      coreutils
    ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      install -Dm755 $src $out/bin/nextflow

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/nextflow \
        --prefix PATH : ${lib.makeBinPath nativeBuildInputs} \
        --set JAVA_HOME ${openjdk17.home}
    '';

    meta = with lib; {
      description = "DSL for data-driven computational pipelines";
      longDescription = ''
        Nextflow is a bioinformatics workflow manager that enables the development of portable and reproducible workflows.

        It supports deploying workflows on a variety of execution platforms including local, HPC schedulers, AWS Batch, Google Cloud Life Sciences, and Kubernetes.

        Additionally, it provides support for manage your workflow dependencies through built-in support for Conda, Docker, Singularity, and Modules.
      '';
      homepage = "https://www.nextflow.io/";
      changelog = "https://github.com/nextflow-io/nextflow/releases";
      license = licenses.asl20;
      maintainers = with maintainers; [
        Etjean
        edmundmiller
      ];
      mainProgram = "nextflow";
      platforms = platforms.unix;
    };
  };
in
if stdenv.isLinux then
  buildFHSEnv {
    name = "nextflow";
    targetPkgs = pkgs: [ nextflow ];
    runScript = "nextflow";
  }
else
  nextflow
