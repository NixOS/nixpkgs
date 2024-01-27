{ stdenv, lib, fetchFromGitHub, writeText, gradle_7, pkg-config, perl, cmake
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
  gradle_ = (gradle_7.override {
    java = openjdk11-bootstrap;
  });

  makePackage = args: stdenv.mkDerivation ({
    version = "${major}${update}-${build}";

    src = fetchFromGitHub {
      owner = "openjdk";
      repo = "jfx${major}u";
      rev = repover;
      sha256 = "sha256-46DjIzcBHkmp5vnhYnLu78CG72bIBRM4A6mgk2OLOko=";
    };

    buildInputs = [ gtk2 gtk3 libXtst libXxf86vm glib alsa-lib ffmpeg_4-headless icu68 ];
    nativeBuildInputs = [ gradle_ perl pkg-config cmake gperf python3 ruby ];

    dontUseCmakeConfigure = true;

    postPatch = ''
      substituteInPlace buildSrc/linux.gradle \
        --replace ', "-Werror=implicit-function-declaration"' ""
    '';

    config = writeText "gradle.properties" (''
      CONF = Release
      JDK_HOME = ${openjdk11-bootstrap.home}
    '' + args.gradleProperties or "");

    buildPhase = ''
      runHook preBuild

      export NUMBER_OF_PROCESSORS=$NIX_BUILD_CORES
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
    outputHash = "sha256-syceJMUEknBDCHK8eGs6rUU3IQn+HnQfURfCrDxYPa9=";
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
    find "$out" -name \*.so | while read lib; do
      new_refs="$(patchelf --print-rpath "$lib" | sed -E 's,:?${openjdk11-bootstrap}[^:]*,,')"
      patchelf --set-rpath "$new_refs" "$lib"
    done

    # Remove licenses, otherwise they may conflict with the ones included in the openjdk
    rm -rf $out/modules_legal/*
  '';

  disallowedReferences = [ openjdk11-bootstrap ];

  passthru.deps = deps;

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
