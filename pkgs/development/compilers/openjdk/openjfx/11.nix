{ lib, fetchFromGitHub, writeText, gradle_7, pkg-config, perl, cmake
, gperf, gtk2, gtk3, libXtst, libXxf86vm, glib, alsa-lib, ffmpeg_4-headless, python3, ruby, icu68
, openjdk11-bootstrap
, withMedia ? true
, withWebKit ? false
}:

let
  major = "11";
  update = ".0.18";
  build = "1";
  repover = "${major}${update}+${build}";
  gradle = (gradle_7.override {
    java = openjdk11-bootstrap;
  });

  makePackage = args: gradle.buildPackage ((builtins.removeAttrs args ["gradleProperties"]) // {
    version = "${major}${update}-${build}";

    src = fetchFromGitHub {
      owner = "openjdk";
      repo = "jfx${major}u";
      rev = repover;
      sha256 = "sha256-46DjIzcBHkmp5vnhYnLu78CG72bIBRM4A6mgk2OLOko=";
    };

    buildInputs = [ gtk2 gtk3 libXtst libXxf86vm glib alsa-lib ffmpeg_4-headless icu68 ];
    nativeBuildInputs = [ gradle perl pkg-config cmake gperf python3 ruby ];

    dontUseCmakeConfigure = true;

    postPatch = ''
      substituteInPlace buildSrc/linux.gradle \
        --replace ', "-Werror=implicit-function-declaration"' ""
    '';

    config = writeText "gradle.properties" (''
      CONF = Release
      JDK_HOME = ${openjdk11-bootstrap.home}
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
          JDK_HOME = ${openjdk11-bootstrap.home}
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
    depsHash = "sha256-ZUx4XJm22rmZXhWypA3QGPrwrguupaL3HivGHtJX2+Y=";
    lockfileTree = ./lockfiles11;
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
    find "$out" -name \*.so | while read lib; do
      new_refs="$(patchelf --print-rpath "$lib" | sed -E 's,:?${openjdk11-bootstrap}[^:]*,,')"
      patchelf --set-rpath "$new_refs" "$lib"
    done

    # Remove licenses, otherwise they may conflict with the ones included in the openjdk
    rm -rf $out/modules_legal/*
  '';

  disallowedReferences = [ openjdk11-bootstrap ];

  # Uses a lot of RAM, OOMs otherwise
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    homepage = "http://openjdk.java.net/projects/openjfx/";
    license = licenses.gpl2;
    description = "The next-generation Java client toolkit";
    maintainers = with maintainers; [ abbradar ];
    platforms = [ "x86_64-linux" ];
  };
}
