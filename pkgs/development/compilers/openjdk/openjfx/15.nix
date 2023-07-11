{ stdenv, lib, fetchFromGitHub, writeText, openjdk11_headless, gradle_6
, pkg-config, perl, cmake, gperf, gtk3, libXtst, libXxf86vm, glib, alsa-lib
, ffmpeg_4-headless, python3, ruby
, withMedia ? true
, withWebKit ? false
}:

let
  major = "15";
  update = ".0.1";
  build = "+1";
  repover = "${major}${update}${build}";
  gradle_ = (gradle_6.override {
    java = openjdk11_headless;
  });

  makePackage = args: stdenv.mkDerivation ({
    version = "${major}${update}${build}";

    src = fetchFromGitHub {
      owner = "openjdk";
      repo = "jfx";
      rev = repover;
      sha256 = "019glq8rhn6amy3n5jc17vi2wpf1pxpmmywvyz1ga8n09w7xscq1";
    };

    buildInputs = [ gtk3 libXtst libXxf86vm glib alsa-lib ffmpeg_4-headless ];
    nativeBuildInputs = [ gradle_ perl pkg-config cmake gperf python3 ruby ];

    dontUseCmakeConfigure = true;

    config = writeText "gradle.properties" (''
      CONF = Release
      JDK_HOME = ${openjdk11_headless.home}
    '' + args.gradleProperties or "");

    env.NIX_CFLAGS_COMPILE = toString [
      #avoids errors about deprecation of GTypeDebugFlags, GTimeVal, etc.
      "-DGLIB_DISABLE_DEPRECATION_WARNINGS"

      # gstreamer workaround for -fno-common toolchains:
      #   ld: gsttypefindelement.o:(.bss._gst_disable_registry_cache+0x0): multiple definition of
      #     `_gst_disable_registry_cache'; gst.o:(.bss._gst_disable_registry_cache+0x0): first defined here
      "-fcommon"
    ];

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
    outputHash = "sha256-fGLTMM9s/Vn7eMzn6OQR3tL0cGbAYc7c4J4/aW3JvkI=";
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

  # glib-2.62 deprecations
  # -fcommon: gstreamer workaround for -fno-common toolchains:
  #   ld: gsttypefindelement.o:(.bss._gst_disable_registry_cache+0x0): multiple definition of
  #     `_gst_disable_registry_cache'; gst.o:(.bss._gst_disable_registry_cache+0x0): first defined here
  env.NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS -fcommon";

  stripDebugList = [ "." ];

  postFixup = ''
    # Remove references to bootstrap.
    export openjdkOutPath='${openjdk11_headless.outPath}'
    find "$out" -name \*.so | while read lib; do
      new_refs="$(patchelf --print-rpath "$lib" | perl -pe 's,:?\Q$ENV{openjdkOutPath}\E[^:]*,,')"
      patchelf --set-rpath "$new_refs" "$lib"
    done
  '';

  disallowedReferences = [ openjdk11_headless ];

  passthru.deps = deps;

  meta = with lib; {
    homepage = "http://openjdk.java.net/projects/openjfx/";
    license = licenses.gpl2;
    description = "The next-generation Java client toolkit";
    maintainers = with maintainers; [ abbradar ];
    knownVulnerabilities = [
      "This OpenJFX version has reached its end of life."
    ];
    platforms = [ "x86_64-linux" ];
  };
}
