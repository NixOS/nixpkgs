{ lib
, stdenv
, fetchFromGitHub
, gradle
, perl
, jre
}:

let
  pname = "vulnz";
  version = "5.1.2";

  src = fetchFromGitHub {
    owner = "jeremylong";
    repo = "Open-Vulnerability-Project";
    rev = "v${version}";
    hash = "sha256-TvyQTbWKZeiA2QTirQK34z7r9WC8wytbTiVZQeBJn/o=";
  };
  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src;
    nativeBuildInputs = [ gradle perl ];
    buildPhase = ''
      runHook preBuild

      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon jar

      runHook postBuild
    '';
    # Mavenize dependency paths
    # e.g. org.codehaus.groovy/groovy/2.4.0/{hash}/groovy-2.4.0.jar -> org/codehaus/groovy/groovy/2.4.0/groovy-2.4.0.jar
    installPhase = ''
      runHook preInstall

      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh

      runHook postInstall
    '';

    # Compensate for the `move-docs.sh` setup hook - is there a way to
    # prevent it from running entirely?
    postFixup = ''
      mv $out/share/info $out/info
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-cjs1STVgGDkStnwfRJN8ddTXDGRyZhuvwD/EThD10L4=";
  };
in stdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

  nativeBuildInputs = [ gradle ];

  buildPhase = ''
    runHook preBuild

    depsDir=$(mktemp -d)
    cp -R ${deps}/* $depsDir
    chmod -R u+w $depsDir

    gradleInit=$(mktemp)
    cat >$gradleInit <<EOF
      gradle.projectsLoaded {
        rootProject.allprojects {
          buildscript {
            repositories {
              clear()
              maven { url '$depsDir' }
            }
          }
          repositories {
            clear()
            maven { url '$depsDir' }
          }
        }
      }

      settingsEvaluated { settings ->
        settings.pluginManagement {
          repositories {
            maven { url '$depsDir' }
          }
        }
      }
    EOF

    export GRADLE_USER_HOME=$(mktemp -d)
    gradle --offline --no-daemon --info --init-script $gradleInit vulnz:bootJar

    runHook preBuild
   '';

  installPhase = ''
    runHook preInstall

    mkdir $out $out/share
    ls vulnz
    cp vulnz/build/libs/vulnz-${version}.jar $out/share

    mkdir $out/bin
    echo "${jre}/bin/java -jar $out/share/${pname}-${version}.jar \$*" > $out/bin/vulnz
    chmod a+x $out/bin/vulnz

    runHook postInstall
  '';

  meta = {
    description = "CLI to work with various vulnerability data-sources";
    longDescription = ''
      The Open Vulnerability Project is a collection of Java libraries and a
      CLI to work with various vulnerability data-sources (NVD, GitHub Security
      Advisories, CISA Known Exploited Vulnerablity Catalog, FIRST Exploit
      Prediction Scoring System (EPSS), etc.).
    '';
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode  # deps
    ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ raboof ];
  };
})
