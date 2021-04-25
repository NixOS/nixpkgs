{ stdenv, lib, fetchFromGitHub, writeText, openjdk11_headless, gradleGen
, pkg-config, perl, cmake, gperf, gtk2, gtk3, libXtst, libXxf86vm, glib, alsaLib
, ffmpeg, python3, ruby }:

let
  major = "16";
  update = "";
  build = "8";
  repover = "${major}${update}+${build}";
  gradle_ = (gradleGen.override {
    java = openjdk11_headless;
  }).gradle_5_6;

  makePackage = args: stdenv.mkDerivation ({
    version = "${major}${update}${build}";

    src = fetchFromGitHub {
      owner = "openjdk";
      repo = "jfx";
      rev = repover;
      sha256 = "15v3xwm8sw9g1cjja0zv49s3fyy6mg0d1gr92b648l4a0qxgmfzb";
    };

    buildInputs = [ gtk2 gtk3 libXtst libXxf86vm glib alsaLib ffmpeg ];
    nativeBuildInputs = [ gradle_ perl pkg-config cmake gperf python3 ruby ];

    dontUseCmakeConfigure = true;

    config = writeText "gradle.properties" (''
      CONF = Release
      JDK_HOME = ${openjdk11_headless.home}
    '' + args.gradleProperties or "");

    #avoids errors about deprecation of GTypeDebugFlags, GTimeVal, etc.
    NIX_CFLAGS_COMPILE = [ "-DGLIB_DISABLE_DEPRECATION_WARNINGS" ];

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
    # Downloaded AWT jars differ by platform.
    outputHash = {
      x86_64-linux = "0hmyr5nnjgwyw3fcwqf0crqg9lny27jfirycg3xmkzbcrwqd6qkw";
      i686-linux = "0hx69p2z96p7jbyq4r20jykkb8gx6r8q2cj7m30pldlsw3650bqx";
    }.${stdenv.system} or (throw "Unsupported platform");
  };

  common = args: makePackage ({
    patches = [
      # libglass.so tries to load GTK to see it is available, so we must add GTK
      # to the RUNPATH of the libglass.so.
      ./add_gtk_to_libglass.patch
      # libstreamer-lite.so loads FFmpeg at runtime, so we must add FFmpeg to the
      # RUNPATH of the libstreamer-lite.so.
      ./add_ffmpeg_to_libgstreamer-lite.patch
    ];

    gradleProperties = ''
      COMPILE_MEDIA = true
      COMPILE_WEBKIT = true
    '';

    preBuild = ''
      swtJar="$(find ${deps} -name org.eclipse.swt\*.jar)"
      substituteInPlace build.gradle \
        --replace 'mavenCentral()' 'mavenLocal(); maven { url uri("${deps}") }' \
        --replace 'name: SWT_FILE_NAME' "files('$swtJar')"
    '';

    stripDebugList = [ "." ];

    postFixup = ''
      # Remove references to bootstrap.
      find "$out" -name \*.so | while read lib; do
        new_refs="$(patchelf --print-rpath "$lib" | sed -E 's,:?${lib.escape ["+"] openjdk11_headless.outPath}[^:]*,,')"
        patchelf --set-rpath "$new_refs" "$lib"
      done
    '';

    disallowedReferences = [ openjdk11_headless ];
  } // args);

in {
  modular-sdk = common {
    pname = "openjfx-modular-sdk";

    installPhase = ''
      cp -r build/modular-sdk $out
    '';

    passthru.deps = deps;

    meta = with lib; {
      homepage = "https://openjdk.java.net/projects/openjfx/";
      license = licenses.gpl2Classpath;
      description = "The next-generation Java client toolkit; unpacked SDK";
      maintainers = with maintainers; [ abbradar ];
      platforms = [ "i686-linux" "x86_64-linux" ];
    };
  };

  sdk = common {
    pname = "openjfx-sdk";

    installPhase = ''
      cp -r build/sdk $out
    '';

    meta = with lib; {
      homepage = "https://openjdk.java.net/projects/openjfx/";
      license = licenses.gpl2Classpath;
      description = "The next-generation Java client toolkit; packed SDK";
      maintainers = with maintainers; [ abbradar ];
      platforms = [ "i686-linux" "x86_64-linux" ];
    };
  };
}
