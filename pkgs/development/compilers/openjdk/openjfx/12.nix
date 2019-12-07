{ stdenv, lib, fetchurl, writeText, openjdk11_headless, gradleGen
, pkgconfig, perl, cmake, gperf, gtk2, gtk3, libXtst, libXxf86vm, glib, alsaLib
, ffmpeg, python, ruby }:

let
  major = "12";
  update = "";
  build = "14";
  repover = "${major}${update}+${build}";
  gradle_ = (gradleGen.override {
    java = openjdk11_headless;
  }).gradle_4_10;

  makePackage = args: stdenv.mkDerivation ({
    version = "${major}${update}-${build}";

    src = fetchurl {
      url = "https://hg.openjdk.java.net/openjfx/${major}/rt/archive/${repover}.tar.gz";
      sha256 = "16jjfjkrg57wsj9mmm52i2kl3byz3ba1f9f8wwc8zwqm4cpjzliz";
    };

    buildInputs = [ gtk2 gtk3 libXtst libXxf86vm glib alsaLib ffmpeg ];
    nativeBuildInputs = [ gradle_ perl pkgconfig cmake gperf python ruby ];

    dontUseCmakeConfigure = true;

    config = writeText "gradle.properties" (''
      CONF = Release
      JDK_HOME = ${openjdk11_headless.home}
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
    # Downloaded AWT jars differ by platform.
    outputHash = {
      x86_64-linux = "1z5qar5l28ja4pkf5l5m48xbv3x1yrnilsv9lpf2j3vkdk9h1nci";
      i686-linux = "0rbygvjc7w197fi5nxldqdrm6mpiyd3n45042g3gd4s5qk08spjd";
    }.${stdenv.system} or (throw "Unsupported platform");
  };

in makePackage {
  pname = "openjfx-modular-sdk";

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

  installPhase = ''
    cp -r build/modular-sdk $out
  '';

  # glib-2.62 deprecations
  NIX_CFLAGS_COMPILE = [ "-DGLIB_DISABLE_DEPRECATION_WARNINGS" ];

  stripDebugList = [ "." ];

  postFixup = ''
    # Remove references to bootstrap.
    find "$out" -name \*.so | while read lib; do
      new_refs="$(patchelf --print-rpath "$lib" | sed -E 's,:?${openjdk11_headless}[^:]*,,')"
      patchelf --set-rpath "$new_refs" "$lib"
    done
  '';

  disallowedReferences = [ openjdk11_headless ];

  passthru.deps = deps;

  meta = with stdenv.lib; {
    homepage = http://openjdk.java.net/projects/openjfx/;
    license = licenses.gpl2;
    description = "The next-generation Java client toolkit.";
    maintainers = with maintainers; [ abbradar ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
