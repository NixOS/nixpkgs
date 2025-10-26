{
  lib,
  stdenv,
  fetchurl,
  undmg,
  dpkg,
  autoPatchelfHook,
  makeShellWrapper,
  # dependencies
  alsa-lib,
  nss,
  gtk3,
  libgbm,
  libGL,
  # runtime dependencies
  cups,
  dbus,
  pango,
}:

let
  pname = "typora";
  version = "1.12.4";

  passthru = {
    sources = {
      x86_64-linux = fetchurl {
        urls = [
          "https://download.typora.io/linux/typora_${version}_amd64.deb"
          "https://downloads.typoraio.cn/linux/typora_${version}_amd64.deb"
        ];
        hash = "sha256-P3wgzMVcyvmXM/w24kPgYGOfSaAh+SFzgeoJoasEmH8=";
      };
      aarch64-linux = fetchurl {
        urls = [
          "https://download.typora.io/linux/typora_${version}_arm64.deb"
          "https://downloads.typoraio.cn/linux/typora_${version}_arm64.deb"
        ];
        hash = "sha256-tQFCppOeeWJK8ovf71LPJRVteOJ8XbbNojhV4QLmVJ0=";
      };
      aarch64-darwin = fetchurl {
        urls = [
          "https://download.typora.io/mac/Typora-${version}.dmg"
          "https://downloads.typoraio.cn/mac/Typora-${version}.dmg"
        ];
        hash = "sha256-XPaMUHmIz+pjT/JQVV9ddNpTWtBDLjyoi5W1Qz9gBAo=";
      };
    };
    updateScript = ./update.sh;
  };

  src =
    passthru.sources.${stdenv.hostPlatform.system}
      or (throw "unsupported system ${stdenv.hostPlatform.system}");

  meta = {
    description = "A minimal Markdown editor and reader.";
    homepage = "https://typora.io/";
    changelog = "https://typora.io/releases/all";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      npulidomateo
      chillcicada
    ];
    platforms = builtins.attrNames passthru.sources;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isLinux {
    mainProgram = "typora";
  };

in

if stdenv.hostPlatform.isDarwin then
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    nativeBuildInputs = [ undmg ];
    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -a Typora.app $out/Applications

      runHook postInstall
    '';
  }
else

  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      passthru
      meta
      ;

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
      makeShellWrapper
    ];

    buildInputs = [
      alsa-lib
      nss
      gtk3
      libgbm
    ];

    runtimeDependencies = map lib.getLib [
      cups
      dbus
      pango
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,share,opt}

      cp -r usr/share/typora $out/opt
      cp -r usr/share/{applications,icons} $out/share

      sed -i '/Change Log/d' "$out/share/applications/typora.desktop"

      makeShellWrapper $out/opt/typora/Typora $out/bin/typora \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}"

      runHook postInstall
    '';
  }
