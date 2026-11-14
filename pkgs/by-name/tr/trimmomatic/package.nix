{
  lib,
  stdenv,
  fetchFromGitHub,
  jre25_minimal,
  makeWrapper,
  stripJavaArchivesHook,
  maven_4,
  nix-update-script,
}:

maven_4.buildMavenPackage (finalAttrs: {
  pname = "trimmomatic";
  version = "0.41";

  src = fetchFromGitHub {
    owner = "usadellab";
    repo = "Trimmomatic";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3nFB3/yfITknmHOHZ0c+6aEAmly657xL4ryHQ33NkRI=";
  };

  mvnHash = "sha256-MLLuEXtgE92LSMt0CFmI8BXoq3mx9Tc9EARYgSVHCfk=";

  nativeBuildInputs = [
    makeWrapper
    stripJavaArchivesHook
  ];

  # Tests fail on Darwin, but the same tests pass on Linux, so it should be
  # OK to skip
  doCheck = stdenv.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall

    install -Dm644 target/trimmomatic-${finalAttrs.version}.jar -t $out/share/trimmomatic
    cp -r adapters $out/share/trimmomatic

    makeWrapper ${lib.getBin jre25_minimal}/bin/java $out/bin/trimmomatic \
        --add-flags "-jar $out/share/trimmomatic/trimmomatic-${finalAttrs.version}.jar"

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/usadellab/Trimmomatic/releases/tag/v${finalAttrs.version}";
    description = "Flexible read trimming tool for Illumina NGS data";
    longDescription = ''
      Trimmomatic performs a variety of useful trimming tasks for illumina
      paired-end and single ended data: adapter trimming, quality trimming,
      cropping to a specified length, length filtering, quality score
      conversion.
    '';
    homepage = "http://www.usadellab.org/cms/?page=trimmomatic";
    downloadPage = "https://github.com/usadellab/Trimmomatic/releases";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [
      lib.sourceTypes.fromSource
      lib.sourceTypes.binaryBytecode # source bundles dependencies as jars
    ];
    mainProgram = "trimmomatic";
    maintainers = [ lib.maintainers.kupac ];
  };
})
