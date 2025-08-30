{
  lib,
  stdenv,
  fetchFromGitHub,
  removeReferencesTo,
  autoconf,
  bash,
  which,
  zip,
  unzip,
  pkg-config,
  cpio,
  file,
  openjdk11,
  openjdk17,
  openjdk21,
  openjdk23,
  openjdk24,
  cups,
  freetype,
  alsa-lib,
  libjpeg,
  giflib,
  libpng,
  zlib,
  lcms2,
  fontconfig,
  xorg,
  cctools,
  darwin,
}:

let
  mkTemurinJDK =
    {
      featureVersion,
      version,
      build,
      hash,
    }:
    let
      bootstrapJdk =
        if featureVersion == "11" then
          openjdk11
        else if lib.versionAtLeast featureVersion "24" then
          openjdk24
        else if lib.versionAtLeast featureVersion "23" then
          openjdk23
        else if lib.versionAtLeast featureVersion "21" then
          openjdk21
        else
          openjdk17;

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      buildConfigMap = lib.genAttrs supportedSystems (
        system:
        let
          parts = lib.strings.splitString "-" system;
          arch = lib.elemAt parts 0;
          os = lib.elemAt parts 1;
          osPrefix =
            {
              linux = "linux";
              darwin = "macosx";
            }
            .${os};
          normalPart = if featureVersion == "11" then "-normal" else "";
        in
        "${osPrefix}-${arch}${normalPart}-server-release"
      );

      buildConfig = buildConfigMap.${stdenv.hostPlatform.system};

    in
    stdenv.mkDerivation (finalAttrs: {
      pname = "temurin-jdk-${featureVersion}";
      version = "${version}+${build}";

      src = fetchFromGitHub {
        owner = "adoptium";
        repo = "jdk${featureVersion}u";
        tag = "jdk-${version}+${build}";
        inherit hash;
      };

      nativeBuildInputs =
        [
          autoconf
          bash
          which
          zip
          unzip
          pkg-config
          cpio
          file
          bootstrapJdk
        ]
        ++ lib.optionals stdenv.isDarwin [
          cctools
          darwin.bootstrap_cmds
          darwin.xattr
          darwin.DarwinTools
          darwin.sigtool
        ];

      buildInputs =
        [
          cups
          freetype
          libjpeg
          giflib
          libpng
          zlib
          lcms2
          fontconfig
        ]
        ++ lib.optionals stdenv.isLinux [
          alsa-lib
          xorg.libX11
          xorg.libXext
          xorg.libXrender
          xorg.libXrandr
          xorg.libXtst
          xorg.libXt
          xorg.libXi
          xorg.xorgproto
        ];

      configurePhase = ''
        runHook preConfigure

        if [ "${featureVersion}" = "21" ] || [ "${featureVersion}" = "23" ] || [ "${featureVersion}" = "24" ]; then
          export SOURCE_DATE_EPOCH=315532802
        fi

        bash configure \
          --with-boot-jdk=${bootstrapJdk} \
          --with-version-opt="nixpkgs" \
          --with-version-pre="" \
          --with-version-build="${build}" \
          --with-vendor-name="NixOS" \
          --with-vendor-url="https://nixos.org/" \
          --with-vendor-bug-url="https://github.com/NixOS/nixpkgs/issues" \
          --enable-unlimited-crypto \
          --with-native-debug-symbols=internal \
          --with-freetype=system \
          --with-libjpeg=system \
          --with-giflib=system \
          --with-libpng=system \
          --with-zlib=system \
          --with-lcms=system \
          --with-cups=${cups.dev} \
          --disable-warnings-as-errors

        runHook postConfigure
      '';

      buildPhase = ''
        runHook preBuild

        make images

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        buildDir="build/${buildConfig}/images/jdk"

        if [ ! -d "$buildDir" ]; then
          exit 1
        fi

        mkdir -p $out
        cp -r "$buildDir"/. "$out"/

        mkdir -p $out/nix-support
        echo 'if [ -z "''${JAVA_HOME-}" ]; then export JAVA_HOME='"$out"'; fi' > $out/nix-support/setup-hook

        runHook postInstall
      '';

      dontStrip = true;
      enableParallelBuilding = true;

      passthru = {
        home = finalAttrs.finalPackage;
        jre = finalAttrs.finalPackage;
      };

      meta = {
        description = "Eclipse Temurin ${featureVersion} JDK - Java Development Kit";
        homepage = "https://adoptium.net/";
        license = lib.licenses.gpl2Classpath;
        maintainers = with lib.maintainers; [ liberodark ];
        platforms = lib.platforms.linux;
        mainProgram = "java";
      };
    });

  mkTemurinJRE =
    {
      jdk,
      featureVersion,
      versionStr,
      buildStr,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "temurin-jre-${featureVersion}";
      version = "${versionStr}+${buildStr}";

      dontUnpack = true;

      nativeBuildInputs = [ removeReferencesTo ];

      buildPhase = ''
        runHook preBuild

        MODULES="java.base"
        MODULES="$MODULES,java.compiler"
        MODULES="$MODULES,java.datatransfer"
        MODULES="$MODULES,java.desktop"
        MODULES="$MODULES,java.instrument"
        MODULES="$MODULES,java.logging"
        MODULES="$MODULES,java.management"
        MODULES="$MODULES,java.management.rmi"
        MODULES="$MODULES,java.naming"
        MODULES="$MODULES,java.net.http"
        MODULES="$MODULES,java.prefs"
        MODULES="$MODULES,java.rmi"
        MODULES="$MODULES,java.scripting"
        MODULES="$MODULES,java.se"
        MODULES="$MODULES,java.security.jgss"
        MODULES="$MODULES,java.security.sasl"
        MODULES="$MODULES,java.smartcardio"
        MODULES="$MODULES,java.sql"
        MODULES="$MODULES,java.sql.rowset"
        MODULES="$MODULES,java.transaction.xa"
        MODULES="$MODULES,java.xml"
        MODULES="$MODULES,java.xml.crypto"
        MODULES="$MODULES,jdk.accessibility"
        MODULES="$MODULES,jdk.charsets"
        MODULES="$MODULES,jdk.crypto.cryptoki"
        MODULES="$MODULES,jdk.dynalink"
        MODULES="$MODULES,jdk.httpserver"
        MODULES="$MODULES,jdk.internal.vm.ci"
        MODULES="$MODULES,jdk.jdwp.agent"
        MODULES="$MODULES,jdk.jfr"
        MODULES="$MODULES,jdk.jsobject"
        MODULES="$MODULES,jdk.localedata"
        MODULES="$MODULES,jdk.management"
        MODULES="$MODULES,jdk.management.agent"
        MODULES="$MODULES,jdk.management.jfr"
        MODULES="$MODULES,jdk.naming.dns"
        MODULES="$MODULES,jdk.naming.rmi"
        MODULES="$MODULES,jdk.net"
        MODULES="$MODULES,jdk.sctp"
        MODULES="$MODULES,jdk.security.auth"
        MODULES="$MODULES,jdk.security.jgss"
        MODULES="$MODULES,jdk.unsupported"
        MODULES="$MODULES,jdk.xml.dom"
        MODULES="$MODULES,jdk.zipfs"

        ${lib.optionalString (featureVersion != "23" && featureVersion != "24") ''
          MODULES="$MODULES,jdk.crypto.ec"
        ''}

        ${lib.optionalString (featureVersion == "23" || featureVersion == "24") ''
          MODULES="$MODULES,jdk.graal.compiler"
          MODULES="$MODULES,jdk.graal.compiler.management"
        ''}

        ${lib.optionalString (featureVersion != "23" && featureVersion != "24") ''
          MODULES="$MODULES,jdk.internal.vm.compiler"
          MODULES="$MODULES,jdk.internal.vm.compiler.management"
        ''}

        ${lib.optionalString (featureVersion == "11") ''
          MODULES="$MODULES,jdk.naming.ldap"
          MODULES="$MODULES,jdk.pack"
          MODULES="$MODULES,jdk.scripting.nashorn"
          MODULES="$MODULES,jdk.scripting.nashorn.shell"
          MODULES="$MODULES,jdk.aot"
          MODULES="$MODULES,jdk.internal.ed"
          MODULES="$MODULES,jdk.internal.le"
        ''}

        ${lib.optionalString
          (lib.elem featureVersion [
            "17"
            "21"
            "23"
            "24"
          ])
          ''
            MODULES="$MODULES,jdk.nio.mapmode"
            MODULES="$MODULES,jdk.incubator.vector"
          ''
        }

        ${lib.optionalString (featureVersion == "17") ''
          MODULES="$MODULES,jdk.incubator.foreign"
        ''}

          COMPRESS_OPT="--compress=2"
        ${lib.optionalString
          (lib.elem featureVersion [
            "21"
            "23"
            "24"
          ])
          ''
            COMPRESS_OPT="--compress zip-2"
          ''
        }

        ${jdk}/bin/jlink \
          --module-path ${jdk}/jmods \
          --add-modules $MODULES \
          --output jre \
          --strip-debug \
          --no-man-pages \
          --no-header-files \
          $COMPRESS_OPT \
          --release-info ${jdk}/release

          runHook postBuild
      '';

      installPhase = ''
        mkdir -p $out
        cp -r jre/* $out/

        mkdir -p $out/nix-support
        cat > $out/nix-support/setup-hook << 'EOF'
        if [ -z "''${JAVA_HOME-}" ]; then
          export JAVA_HOME=$out
        fi
        EOF
      '';

      preFixup = ''
        find $out -type f -exec remove-references-to -t ${jdk} {} + || true
      '';

      passthru = {
        home = finalAttrs.finalPackage;
        jdk = jdk;
      };

      meta = jdk.meta // {
        description = "Eclipse Temurin ${featureVersion} JRE - Java Runtime Environment";
      };
    });

  versions = {
    "11" = {
      version = "11.0.26";
      build = "4";
      hash = "sha256-7yeyr2UbMntuOtEjRLdLoiyN0zC+fZZSGL9XxI2D7GU=";
    };
    "17" = {
      version = "17.0.14";
      build = "7";
      hash = "sha256-Vc1+8xnKmNQkCzeHoW8Y2WuxU7G5IAfRYXMp8JrjFuQ=";
    };
    "21" = {
      version = "21.0.6";
      build = "7";
      hash = "sha256-GOx8awClA96VFpUhACYV+wtFM1qD29X0s3utIWWY+Nc=";
    };
    "23" = {
      version = "23.0.2";
      build = "7";
      hash = "sha256-zlL2DV6iOfV3hgq/Ci95gTwVrhcvz5MWsg4/+O2ntE8=";
    };
    "24" = {
      version = "24.0.1";
      build = "9";
      hash = "sha256-vXZNi6whn0GpL02DBaGAp40vYOP6BkJrLOhhL9df2kA=";
    };
  };

  jdks = lib.mapAttrs (
    featureVersion: versionInfo:
    mkTemurinJDK {
      inherit featureVersion;
      inherit (versionInfo) version build hash;
    }
  ) versions;

in
{
  temurin-jdk-11 = jdks."11";
  temurin-jdk-17 = jdks."17";
  temurin-jdk-21 = jdks."21";
  temurin-jdk-23 = jdks."23";
  temurin-jdk-24 = jdks."24";

  temurin-jre-11 = mkTemurinJRE {
    jdk = jdks."11";
    featureVersion = "11";
    versionStr = versions."11".version;
    buildStr = versions."11".build;
  };
  temurin-jre-17 = mkTemurinJRE {
    jdk = jdks."17";
    featureVersion = "17";
    versionStr = versions."17".version;
    buildStr = versions."17".build;
  };
  temurin-jre-21 = mkTemurinJRE {
    jdk = jdks."21";
    featureVersion = "21";
    versionStr = versions."21".version;
    buildStr = versions."21".build;
  };
  temurin-jre-23 = mkTemurinJRE {
    jdk = jdks."23";
    featureVersion = "23";
    versionStr = versions."23".version;
    buildStr = versions."23".build;
  };
  temurin-jre-24 = mkTemurinJRE {
    jdk = jdks."24";
    featureVersion = "24";
    versionStr = versions."24".version;
    buildStr = versions."24".build;
  };

  temurin = jdks."21";
  temurin-jdk = jdks."21";
  temurin-jre = mkTemurinJRE {
    jdk = jdks."21";
    featureVersion = "21";
    versionStr = versions."21".version;
    buildStr = versions."21".build;
  };
}
