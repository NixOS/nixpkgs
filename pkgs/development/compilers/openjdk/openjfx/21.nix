{ stdenv, lib, fetchFromGitHub, writeText, openjdk17_headless
, openjdk21_headless, gradle_7, pkg-config, perl, cmake, gperf, gtk2, gtk3, libXtst
, libXxf86vm, glib, alsa-lib, ffmpeg_4, python3, ruby, fetchurl, runCommand
, withMedia ? true
, withWebKit ? false
}:

let
  major = "21";
  update = "";
  build = "-ga";
  repover = "${major}${update}${build}";
  gradle_ = (gradle_7.override {
    # note: gradle does not yet support running on 19
    java = openjdk17_headless;
  });

  icuVersionWithSep = s: "73${s}1";
  icuPath = "download/release-${icuVersionWithSep "-"}/icu4c-${icuVersionWithSep "_"}-data-bin-l.zip";
  icuData = fetchurl {
    url = "https://github.com/unicode-org/icu/releases/${icuPath}";
    hash = "sha256-QDgpjuAqDDiRcYXvj/Tr3pyLVSx3f9A+TfbGtLGCXiA=";
  };
  icuFakeRepository = runCommand "icu-data-repository" {} ''
    install -Dm644 ${icuData} $out/${icuPath}
  '';

  makePackage = args: stdenv.mkDerivation ({
    version = "${major}${update}${build}";

    src = fetchFromGitHub {
      owner = "openjdk";
      repo = "jfx";
      rev = repover;
      hash = "sha256-deNAGfnA6gwcAa64l0AWdkX+vJd3ZOfIgAifSl+/m+s=";
    };

    buildInputs = [ gtk2 gtk3 libXtst libXxf86vm glib alsa-lib ffmpeg_4 ];
    nativeBuildInputs = [ gradle_ perl pkg-config cmake gperf python3 ruby ];

    dontUseCmakeConfigure = true;

    postPatch = ''
      # Add missing includes for gcc-13 for webkit build:
      sed -e '1i #include <cstdio>' \
        -i modules/javafx.web/src/main/native/Source/bmalloc/bmalloc/Heap.cpp \
           modules/javafx.web/src/main/native/Source/bmalloc/bmalloc/IsoSharedPageInlines.h
    '';

    config = writeText "gradle.properties" (''
      CONF = Release
      JDK_HOME = ${openjdk21_headless.home}
    '' + args.gradleProperties or "");

    buildPhase = ''
      runHook preBuild

      export NUMBER_OF_PROCESSORS=$NIX_BUILD_CORES
      export GRADLE_USER_HOME=$(mktemp -d)
      ln -s $config gradle.properties
      export NIX_CFLAGS_COMPILE="$(pkg-config --cflags glib-2.0) $NIX_CFLAGS_COMPILE"
      gradle --no-daemon --console=plain $gradleFlags sdk

      runHook postBuild
    '';
  } // args);

  # Fake build to pre-download deps into fixed-output derivation.
  # We run nearly full build because I see no other way to download everything that's needed.
  # Anyone who knows a better way?
  deps = makePackage {
    pname = "openjfx-deps";

    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME -type f -regex '.*/modules.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
      rm -rf $out/tmp
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    # suspiciously the same as for openjfx 17 ...
    # could they really not have changed any of their dependencies?
    # or did we miss changing another upstream hash when copy-pasting?
    outputHash = "sha256-dV7/U5GpFxhI13smZ587C6cVE4FRNPY0zexZkYK4Yqo=";
  };

in makePackage {
  pname = "openjfx-modular-sdk";

  gradleProperties = ''
    COMPILE_MEDIA = ${lib.boolToString withMedia}
    COMPILE_WEBKIT = ${lib.boolToString withWebKit}
    ${lib.optionalString withWebKit "icuRepositoryURL = file://${icuFakeRepository}"}
  '';

  preBuild = ''
    swtJar="$(find ${deps} -name org.eclipse.swt\*.jar)"
    substituteInPlace build.gradle \
      --replace 'mavenCentral()' 'mavenLocal(); maven { url uri("${deps}") }' \
      --replace 'name: SWT_FILE_NAME' "files('$swtJar')"
  '';

  installPhase = ''
    cp -r build/modular-sdk $out
  '';

  stripDebugList = [ "." ];

  postFixup = ''
    # Remove references to bootstrap.
    export openjdkOutPath='${openjdk21_headless.outPath}'
    find "$out" -name \*.so | while read lib; do
      new_refs="$(patchelf --print-rpath "$lib" | perl -pe 's,:?\Q$ENV{openjdkOutPath}\E[^:]*,,')"
      patchelf --set-rpath "$new_refs" "$lib"
    done
  '';

  disallowedReferences = [ openjdk17_headless openjdk21_headless ];

  passthru.deps = deps;

  meta = with lib; {
    homepage = "https://openjdk.org/projects/openjfx/";
    license = licenses.gpl2Classpath;
    description = "Next-generation Java client toolkit";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
