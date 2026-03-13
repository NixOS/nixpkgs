{
  lib,
  fetchFromGitHub,
  gitUpdater,
  testers,
  use,
  coreutils,
  jdk,
  makeWrapper,
  maven,
}:

let
  jdk' = jdk.override { enableJavaFX = true; };
in
maven.buildMavenPackage rec {
  pname = "use";
  version = "7.5.0";

  src = fetchFromGitHub {
    owner = "useocl";
    repo = "use";
    tag = "v${version}";
    hash = "sha256-FftXEq5HHQ7SVmcKspg3fN37PCYKO6Xq0alAPnoeAXA=";
  };

  patches = [
    ./remove-pom-jfx.patch
  ];

  mvnJdk = jdk';

  mvnHash = "sha256-rYOmlPSkUznx1rC9XjNC8TO6da3zYeseiu0O2No8Gxs=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    gunzip -ck ./use-assembly/target/use-${version}-use-bin.tar.gz | tar -xvf-
    mv use-${version} $out

    wrapProgram $out/bin/use \
      --prefix PATH : ${
        lib.makeBinPath [
          jdk'
          coreutils # dirname
        ]
      }

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = use;
      command = "use -V";
    };
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = {
    description = "UML-based Specification Environment";
    homepage = "https://github.com/useocl/use";
    license = lib.licenses.gpl2Plus;
    mainProgram = "use";
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
  };
}
