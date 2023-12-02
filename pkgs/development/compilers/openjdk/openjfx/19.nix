{ stdenv, lib, fetchFromGitHub, fetchpatch, writeText, openjdk17_headless
, openjdk19_headless, gradle_7, pkg-config, perl, cmake, gperf, gtk2, gtk3, libXtst
, libXxf86vm, glib, alsa-lib, ffmpeg_4, python3, ruby, icu68
, withMedia ? true
, withWebKit ? false
}:

let
  major = "19";
  update = ".0.2.1";
  build = "+1";
  repover = "${major}${update}${build}";
  gradle_ = (gradle_7.override {
    # note: gradle does not yet support running on 19
    java = openjdk17_headless;
  });

  makePackage = args: stdenv.mkDerivation ({
    version = "${major}${update}${build}";

    src = fetchFromGitHub {
      owner = "openjdk";
      repo = "jfx";
      rev = repover;
      hash = "sha256-A08GhCGpzWlUG1+f6mcjvkJmMNaOReacQKPEmNpUvLs=";
    };

    patches = [
      # 8295962: Reference to State in Task.java is ambiguous when building with JDK 19
      (fetchpatch {
        url = "https://github.com/openjdk/jfx/pull/933/commits/cfaee2a52350eff39dd4352484c892716076d3de.patch";
        hash = "sha256-hzJMenhvtmHs/6BJj8GfaLp14myV8VCXCLLC8n32yEw=";
      })
      # ditto
      (fetchpatch {
        url = "https://github.com/openjdk/jfx/pull/933/commits/bd46ce12df0a93a56fe0d58d3653d08e58409b7f.patch";
        hash = "sha256-o9908uw9vYvULmAh/lbfyHhgxz6jpgPq2fcAltWsYoU=";
      })
    ];

    buildInputs = [ gtk2 gtk3 libXtst libXxf86vm glib alsa-lib ffmpeg_4 icu68 ];
    nativeBuildInputs = [ gradle_ perl pkg-config cmake gperf python3 ruby ];

    dontUseCmakeConfigure = true;

    config = writeText "gradle.properties" (''
      CONF = Release
      JDK_HOME = ${openjdk19_headless.home}
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
    export openjdkOutPath='${openjdk19_headless.outPath}'
    find "$out" -name \*.so | while read lib; do
      new_refs="$(patchelf --print-rpath "$lib" | perl -pe 's,:?\Q$ENV{openjdkOutPath}\E[^:]*,,')"
      patchelf --set-rpath "$new_refs" "$lib"
    done
  '';

  disallowedReferences = [ openjdk17_headless openjdk19_headless ];

  passthru.deps = deps;

  meta = with lib; {
    homepage = "https://openjdk.org/projects/openjfx/";
    license = licenses.gpl2Classpath;
    description = "The next-generation Java client toolkit";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
  };
}
