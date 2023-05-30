{ lib, fetchFromGitHub, writeText, openjdk17_headless, gradle_7
, pkg-config, perl, cmake, gperf, gtk2, gtk3, libXtst, libXxf86vm, glib, alsa-lib
, ffmpeg_4-headless, python3, ruby, icu71, fetchurl, runCommand
, withMedia ? true
, withWebKit ? false
}:

let
  major = "17";
  update = ".0.6";
  build = "+3";
  repover = "${major}${update}${build}";
  gradle = (gradle_7.override {
    java = openjdk17_headless;
  });

  dashed-icu-version = lib.concatStringsSep "-" (lib.splitString "." (lib.getVersion icu71));
  underscored-icu-version = lib.concatStringsSep "_" (lib.splitString "." (lib.getVersion icu71));
  icu-data = fetchurl {
    url = "https://github.com/unicode-org/icu/releases/download/release-${dashed-icu-version}/icu4c-${underscored-icu-version}-data-bin-l.zip";
    hash = "sha256-pVWIy0BkICsthA5mxhR9SJQHleMNnaEcGl/AaLi5qZM=";
  };

  fakeRepository = runCommand "icu-data-repository" {} ''
    mkdir -p $out/download/release-${dashed-icu-version}
    cp ${icu-data} $out/download/release-${dashed-icu-version}/icu4c-${underscored-icu-version}-data-bin-l.zip
  '';

  makePackage = args: gradle.buildPackage ((builtins.removeAttrs args ["gradleProperties"]) // {
    version = "${major}${update}${build}";

    src = fetchFromGitHub {
      owner = "openjdk";
      repo = "jfx${major}u";
      rev = repover;
      sha256 = "sha256-9VfXk2EfMebMyVKPohPRP2QXRFf8XemUtfY0JtBCHyw=";
    };

    buildInputs = [ gtk2 gtk3 libXtst libXxf86vm glib alsa-lib ffmpeg_4-headless icu71 ];
    nativeBuildInputs = [ gradle perl pkg-config cmake gperf python3 ruby ];

    dontUseCmakeConfigure = true;

    config = writeText "gradle.properties" (''
      CONF = Release
      JDK_HOME = ${openjdk17_headless.home}
    '' + args.gradleProperties or "");

    preBuild = ''
      ln -s $config gradle.properties
      export NIX_CFLAGS_COMPILE="$(pkg-config --cflags glib-2.0) $NIX_CFLAGS_COMPILE"
    '' + (args.preBuild or "");

    gradleOpts = {
      buildSubcommand = "sdk";
      depsAttrs = {
        disallowedReferences = [ ];
        config = writeText "gradle.properties" ''
          CONF = Release
          JDK_HOME = ${openjdk17_headless.home}
        '';
        preBuild = ''
          ln -s $config gradle.properties
          export NIX_CFLAGS_COMPILE="$(pkg-config --cflags glib-2.0) $NIX_CFLAGS_COMPILE"
        '';
      };
    } // (args.gradleOpts or {});
  } // args);
in makePackage {
  pname = "openjfx-modular-sdk";

  gradleOpts = {
    depsHash = "sha256-q9iiiNPacZuX2XuUxpsShpCXbsxGIgF7wua9dQBac/I=";
    lockfileTree = ./lockfiles17;
  };

  gradleProperties = ''
    COMPILE_MEDIA = ${lib.boolToString withMedia}
    COMPILE_WEBKIT = ${lib.boolToString withWebKit}
    ${lib.optionalString withWebKit "icuRepositoryURL = file://${fakeRepository}"}
  '';

  preBuild = ''
    swtJar="$(find $deps -name org.eclipse.swt\*.jar)"
    substituteInPlace build.gradle \
      --replace 'name: SWT_FILE_NAME' "files('$swtJar')"
  '';

  installPhase = ''
    cp -r build/modular-sdk $out
  '';

  stripDebugList = [ "." ];

  postFixup = ''
    # Remove references to bootstrap.
    export openjdkOutPath='${openjdk17_headless.outPath}'
    find "$out" -name \*.so | while read lib; do
      new_refs="$(patchelf --print-rpath "$lib" | perl -pe 's,:?\Q$ENV{openjdkOutPath}\E[^:]*,,')"
      patchelf --set-rpath "$new_refs" "$lib"
    done
  '';

  disallowedReferences = [ openjdk17_headless ];

  meta = with lib; {
    homepage = "http://openjdk.java.net/projects/openjfx/";
    license = licenses.gpl2;
    description = "The next-generation Java client toolkit";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
