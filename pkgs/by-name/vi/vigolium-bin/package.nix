{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  buildFHSEnv,
  writeShellScript,
}:

let
  pname = "vigolium-bin";
  version = "0.5.1";
  targets = {
    x86_64-linux = {
      suffix = "linux_amd64";
      hash = "sha256-NP00jv5MZM8ntYkPsXD3L4YxfPGt5N3LTmNC7gnl5k4=";
    };
    aarch64-linux = {
      suffix = "linux_arm64";
      hash = "sha256-FAyWlnWjzQrh/LykXSEguSU1C1UQgMH++t2/prbzdV0=";
    };
    aarch64-darwin = {
      suffix = "darwin_arm64";
      hash = "sha256-aX5xHuGekJQDT8KdvqzVPXnTr5xt2blyemhm67bIpfI=";
    };
  };
  target = targets.${stdenvNoCC.hostPlatform.system};
  licenseFile = fetchurl {
    url = "https://raw.githubusercontent.com/vigolium/vigolium/v${version}/LICENSE";
    hash = "sha256-5ltwW9fJEtk1ntxSxmIMXpf3wYe9RNapJsTiWNYy0vw=";
  };
  notices = fetchurl {
    url = "https://raw.githubusercontent.com/vigolium/vigolium/v${version}/THIRD_PARTY_NOTICES.md";
    hash = "sha256-JNrbtGC/dD4WpJUUSC5aB3VA5TabyD3g8f4QgKmSFjo=";
  };
  unwrapped = stdenvNoCC.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit version;
    src = fetchurl {
      url = "https://github.com/vigolium/vigolium/releases/download/v${version}/vigolium_${version}_${target.suffix}.tar.gz";
      inherit (target) hash;
    };
    sourceRoot = ".";
    dontConfigure = true;
    dontBuild = true;
    # The Go binary embeds Bun executables which are extracted at runtime.
    # Preserve their bytes; the Linux wrapper supplies their FHS interpreter paths.
    dontFixup = true;
    installPhase = ''
      runHook preInstall

      install -Dm755 vigolium $out/bin/vigolium
      echo nix > $out/bin/.vigolium-package-manager
      install -Dm644 ${licenseFile} $out/share/licenses/vigolium/LICENSE
      install -Dm644 ${notices} $out/share/doc/vigolium/THIRD_PARTY_NOTICES.md

      runHook postInstall
    '';
  };
  passthru = { inherit unwrapped; };
  meta = {
    description = "Web vulnerability scanner and traffic analysis CLI";
    homepage = "https://vigolium.com";
    changelog = "https://github.com/vigolium/vigolium/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames targets;
    maintainers = with lib.maintainers; [ j3ssie ];
    mainProgram = "vigolium";
  };
in
if stdenvNoCC.hostPlatform.isLinux then
  buildFHSEnv {
    inherit
      pname
      version
      passthru
      meta
      ;
    executableName = "vigolium";
    targetPkgs =
      pkgs: with pkgs; [
        glibc
        stdenv.cc.cc.lib
        zlib
        cacert
        bash
        coreutils
        git
      ];
    runScript = writeShellScript "vigolium-launch" ''
      export VIGOLIUM_PACKAGE_MANAGER=nix
      export VIGOLIUM_DISABLE_UPDATE_CHECK=1
      exec ${lib.getExe' unwrapped "vigolium"} "$@"
    '';
    extraInstallCommands = ''
      ln -s ${unwrapped}/share $out/share
    '';
  }
else
  stdenvNoCC.mkDerivation {
    inherit
      pname
      version
      passthru
      meta
      ;
    dontUnpack = true;
    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      runHook preInstall

      makeWrapper ${lib.getExe' unwrapped "vigolium"} $out/bin/vigolium \
        --set VIGOLIUM_PACKAGE_MANAGER nix \
        --set VIGOLIUM_DISABLE_UPDATE_CHECK 1
      ln -s ${unwrapped}/share $out/share

      runHook postInstall
    '';
  }
