{ stdenv, lib, fetchFromGitHub, fetchurl, writeText, openjdk17_headless, gradle_7
, pkg-config, perl, cmake, gperf, gtk2, gtk3, libXtst, libXxf86vm, glib, alsa-lib
, ffmpeg_4-headless, python3, ruby, icu68
, withMedia ? true
, withWebKit ? false
}:

let
  major = "17";
  update = ".0.6";
  build = "+3";
  repover = "${major}${update}${build}";
  gradle_ = (gradle_7.override {
    java = openjdk17_headless;
  });

  makePackage = args: stdenv.mkDerivation ({
    version = "${major}${update}${build}";

    src = fetchFromGitHub {
      owner = "openjdk";
      repo = "jfx${major}u";
      rev = repover;
      sha256 = "sha256-9VfXk2EfMebMyVKPohPRP2QXRFf8XemUtfY0JtBCHyw=";
    };

    buildInputs = [ gtk2 gtk3 libXtst libXxf86vm glib alsa-lib ffmpeg_4-headless icu68 ];
    nativeBuildInputs = [ gradle_ perl pkg-config cmake gperf python3 ruby ];

    dontUseCmakeConfigure = true;

    config = writeText "gradle.properties" (''
      CONF = Release
      JDK_HOME = ${openjdk17_headless.home}
    '' + args.gradleProperties or "");

    buildPhase = ''
      runHook preBuild

      export GRADLE_USER_HOME=$(mktemp -d)
      ln -s $config gradle.properties
      export NIX_CFLAGS_COMPILE="$(pkg-config --cflags glib-2.0) $NIX_CFLAGS_COMPILE"
      gradle --no-daemon $gradleFlags sdk

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
    outputHash = "sha256-dV7/U5GpFxhI13smZ587C6cVE4FRNPY0zexZkYK4Yqo=";
  };

  # ICU data file.
  # The Gradle build copies this file to the WebKit binary dir, where the WebKit build expects to unzip it.
  icuDataVersion = s: "71" + s + "1";
  icuDataZip = fetchurl {
    url = "https://github.com/unicode-org/icu/releases/download/release-${icuDataVersion "-"}/icu4c-${icuDataVersion "_"}-data-bin-l.zip";
    sha256 = "sha256-pVWIy0BkICsthA5mxhR9SJQHleMNnaEcGl/AaLi5qZM=";
  };

in makePackage {
  pname = "openjfx-modular-sdk";

  gradleProperties = ''
    COMPILE_MEDIA = ${lib.boolToString withMedia}
    COMPILE_WEBKIT = ${lib.boolToString withWebKit}
  '';

  preBuild = ''
    swtJar="$(find ${deps} -name org.eclipse.swt\*.jar)"
    substituteInPlace build.gradle \
      --replace 'mavenCentral()' 'mavenLocal(); maven { url uri("${deps}") }' \
      --replace 'name: SWT_FILE_NAME' "files('$swtJar')"
  '' +
  (if withWebKit then ''
    # Verify that we are supplying the correct ICU version
    if ! requiredVersion="$(grep -Po 'defineProperty\("icuVersion", "\K.+(?="\))' build.gradle)"; then
      echo >&2 "Error: Cannot find required ICU version"
      exit 1
    fi
    providedVersion="${icuDataVersion "."}"
    if [ "$requiredVersion" != "$providedVersion" ]; then
      echo >&2 "Error: ICU version mismatch"
      echo >&2 "  Required: $requiredVersion"
      echo >&2 "  Provided: $providedVersion"
      exit 1
    fi
    # Providing with a file name matching `icu4c-*.zip`
    icuZip="$(pwd)/icu4c-data-bin-l.zip"
    ln -s ${icuDataZip} "$icuZip"
    substituteInPlace build.gradle \
      --replace 'icu name: "icu4c-''${icuFileVersion}-data-bin-l", ext: "zip"' "icu files('$icuZip')"
  '' else "");

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

  passthru.deps = deps;

  meta = with lib; {
    homepage = "http://openjdk.java.net/projects/openjfx/";
    license = licenses.gpl2;
    description = "The next-generation Java client toolkit";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
