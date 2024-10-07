{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  openjdk,
  gradle,
  wget,
  which,
  gnused,
  gawk,
  coreutils,
  bash,
  testers,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nextflow";
  # 24.08.0-edge is compatible with Java 21. The current (as of 2024-09-19)
  # nextflow release (24.04.4) does not yet support java21, but java19. The
  # latter is not in nixpkgs(-unstable) anymore.
  version = "24.08.0-edge";

  src = fetchFromGitHub {
    owner = "nextflow-io";
    repo = "nextflow";
    rev = "6e866ae81ff3bf8a9729e9dbaa9dd89afcb81a4b";
    hash = "sha256-SA27cuP3iO5kD6u0uTeEaydyqbyJzOkVtPrb++m3Tv0=";
  };

  nativeBuildInputs = [
    makeWrapper
    gradle
  ];

  postPatch = ''
    # Nextflow invokes the constant "/bin/bash" (not as a shebang) at
    # several locations so we fix that globally. However, when running inside
    # a container, we actually *want* "/bin/bash". Thus the global fix needs
    # to be reverted for this specific use case.
    substituteInPlace modules/nextflow/src/main/groovy/nextflow/executor/BashWrapperBuilder.groovy \
      --replace-fail "['/bin/bash'," "['${bash}/bin/bash'," \
      --replace-fail "if( containerBuilder ) {" "if( containerBuilder ) {
                launcher = launcher.replaceFirst(\"/nix/store/.*/bin/bash\", \"/bin/bash\")"
  '';

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };
  __darwinAllowLocalNetworking = true;

  # During the build, some additional dependencies are downloaded ("detached
  # configuration"). We thus need to run a full build on instead of the default
  # one.
  # See https://github.com/NixOS/nixpkgs/pull/339197#discussion_r1747749061
  gradleUpdateTask = "pack";
  # The installer attempts to copy a final JAR to $HOME/.nextflow/...
  gradleFlags = ["-Duser.home=\$TMPDIR"];
  preBuild = ''
    # See Makefile (`make pack`)
    export BUILD_PACK=1
  '';
  gradleBuildTask = "pack";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 build/releases/nextflow-${finalAttrs.version}-dist $out/bin/nextflow

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/nextflow \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gawk
          gnused
          wget
          which
        ]
      } \
      --set JAVA_HOME ${openjdk.home}
  '';

  passthru.tests.default = nixosTests.nextflow;
  # versionCheckHook doesn't work as of 2024-09-23.
  # See https://github.com/NixOS/nixpkgs/pull/339197#issuecomment-2363495060
  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "env HOME=$TMPDIR nextflow -version";
  };

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
})
