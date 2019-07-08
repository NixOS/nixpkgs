{ stdenv, fetchurl, writeText, openjdk, bootjdk, gradleGen, pkgconfig, perl, cmake, gperf
, gtk2, gtk3, libXtst, libXxf86vm, glib, alsaLib, ffmpeg, python, ruby }:

let
  major = "11";
  update = ".0.3";
  build = "1";
  repover = "${major}${update}+${build}";
  gradle_ = (gradleGen.override {
    jdk = bootjdk;
  }).gradle_4_10;

  makePackage = args: stdenv.mkDerivation ({
    version = "${major}${update}-${repover}";

    src = fetchurl {
      url = "http://hg.openjdk.java.net/openjfx/${major}/rt/archive/${repover}.tar.gz";
      sha256 = "1h7qsylr7rnwnbimqjyn3whszp9kv4h3gpicsrb3mradxc9yv194";
    };

    buildInputs = [ gtk2 gtk3 libXtst libXxf86vm glib alsaLib ffmpeg ];
    nativeBuildInputs = [ gradle_ perl pkgconfig cmake gperf python ruby ];

    dontUseCmakeConfigure = true;

    config = writeText "gradle.properties" (''
      CONF = Release
      JDK_HOME = ${bootjdk}/lib/openjdk
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
      find $GRADLE_USER_HOME -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
      rm -rf $out/tmp
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash =
      # Downloaded AWT jars differ by platform.
      if stdenv.system == "x86_64-linux" then "0d4msxswdav1xsfkpr0qd3xgqkcbxzf47v1zdy5jmg5w4bs6a78a"
      else if stdenv.system == "i686-linux" then "0mjlyf6jvbis7nrm5d394sjv4hjw6k3753hr1nwdxk8skwc3ry08"
      else throw "Unsupported platform";
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

  stripDebugList = [ "." ];

  postFixup = ''
    # Remove references to bootstrap.
    find "$out" -name \*.so | while read lib; do
      new_refs="$(patchelf --print-rpath "$lib" | sed -E 's,:?${bootjdk}[^:]*,,')"
      patchelf --set-rpath "$new_refs" "$lib"
    done

    # Test to make sure that we don't depend on the bootstrap
    if grep -q -r '${bootjdk}' "$out"; then
      echo "Extraneous references to ${bootjdk} detected" >&2
      exit 1
    fi
  '';

  passthru.deps = deps;

  meta = with stdenv.lib; {
    homepage = http://openjdk.java.net/projects/openjfx/;
    license = openjdk.meta.license;
    description = "The next-generation Java client toolkit.";
    maintainers = with maintainers; [ abbradar ];
    platforms = openjdk.meta.platforms;
  };
}
