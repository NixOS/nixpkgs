{ lib, fetchFromGitHub, writeText, openjdk11_headless, gradle_6
, pkg-config, cmake, gperf, gtk2, gtk3, libXtst, libXxf86vm, glib, alsa-lib
, ffmpeg_4-headless, python3, ruby
, withMedia ? true
, withWebKit ? false
}:

let
  major = "15";
  update = ".0.1";
  build = "+1";
  repover = "${major}${update}${build}";
  gradle = (gradle_6.override {
    java = openjdk11_headless;
  });

  makePackage = args: gradle.buildPackage ((builtins.removeAttrs args ["gradleProperties"]) // {
    version = "${major}${update}${build}";

    src = fetchFromGitHub {
      owner = "openjdk";
      repo = "jfx";
      rev = repover;
      sha256 = "019glq8rhn6amy3n5jc17vi2wpf1pxpmmywvyz1ga8n09w7xscq1";
    };

    buildInputs = [ gtk2 gtk3 libXtst libXxf86vm glib alsa-lib ffmpeg_4-headless ];
    nativeBuildInputs = [ pkg-config cmake gperf python3 ruby ];

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
          JDK_HOME = ${openjdk11_headless.home}
        '';
        preBuild = ''
          ln -s $config gradle.properties
          export NIX_CFLAGS_COMPILE="$(pkg-config --cflags glib-2.0) $NIX_CFLAGS_COMPILE"
        '';
      };
    } // (args.gradleOpts or {});
  });
in makePackage {
  pname = "openjfx-modular-sdk";

  gradleOpts = {
    depsHash = "sha256-IB7386OOwa7fL85dmpK/gpMC3GtTqnidTt/YygQ/NQ0=";
    lockfileTree = ./lockfiles15;
  };

  gradleProperties = ''
    COMPILE_MEDIA = ${lib.boolToString withMedia}
    COMPILE_WEBKIT = ${lib.boolToString withWebKit}
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
    export openjdkOutPath='${openjdk11_headless.outPath}'
    find "$out" -name \*.so | while read lib; do
      new_refs="$(patchelf --print-rpath "$lib" | perl -pe 's,:?\Q$ENV{openjdkOutPath}\E[^:]*,,')"
      patchelf --set-rpath "$new_refs" "$lib"
    done
  '';

  disallowedReferences = [ openjdk11_headless ];

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
