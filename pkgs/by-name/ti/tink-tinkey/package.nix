{
  bazel_7,
  buildBazelPackage,
  fetchFromGitHub,
  fetchurl,
  gitMinimal,
  jdk,
  lib,
  makeBinaryWrapper,
  stdenvNoCC,
}:
let
  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "3f863a3f35f31b61982d813835d8637b3d93d87a";
    hash = "sha256-BsxP3GrS98ubIAkFx/c4pB1i97ZZL2TijS+2ORnooww=";
  };
  bazelDeps = import ./bazel-deps.nix {
    fetchurl =
      args:
      stdenvNoCC.mkDerivation {
        name = "bazel-dep-unpacked";
        src = fetchurl args;
        dontUnpack = true;
        dontConfigure = true;
        dontBuild = true;
        installPhase = ''
          mkdir $out
          tar -C $out -xf $src
          chmod -R u+w $out
          shopt -s dotglob nullglob
          files=($out/*)
          if [ ''${#files[@]} -eq 1 ] && [ -d "''${files[0]}" ]; then
            tmp="''${files[0]}.tmp"
            mv "''${files[0]}" "$tmp"
            mv "$tmp"/* $out/
            rmdir "$tmp"
          fi
        '';
      };
  };
in
buildBazelPackage rec {
  pname = "tink-tinkey";
  version = "1.13.0";

  env = {
    JAVA_HOME = jdk.home;
    USE_BAZEL_VERSION = bazel_7.version;
  };

  src = fetchFromGitHub {
    owner = "tink-crypto";
    repo = "tink-tinkey";
    tag = "v${version}";
    hash = "sha256-x6GST/g7p+MiumXseB9KtFp0xzCSJT8u5nYQioFP7GA=";
  };

  nativeBuildInputs = [
    gitMinimal
    jdk
    makeBinaryWrapper
  ];

  bazel = bazel_7;

  bazelTargets = [ "//:tinkey_deploy.jar" ];

  fetchConfigured = true;

  bazelFlags = [
    "--registry"
    "file://${registry}"
    "--tool_java_runtime_version=local_jdk"
    "--java_runtime_version=local_jdk"
  ]
  ++ (lib.sort (a: b: a < b) (
    lib.mapAttrsToList (name: dep: "--override_repository=${name}=${dep}") bazelDeps
  ));

  fetchAttrs = {
    /*
      Remove all auto-generated local toolchains and their marker
      files to fix fetch phase non-determinism (e.g. from different
      CPU counts in CI)
    */
    preInstall = ''
      rm -rf \
        "$bazelOut"/external/{*local_config_*,*local_jdk*,*remotejdk*,*remote_jdk*,*bazel_tools*,*sh_posix_config*,*.marker,rules_jvm_external~~maven~maven/*_argsfile}
    '';

    hash =
      {
        x86_64-linux = "sha256-z+DmP98TkLzHuwo0k6jzJRDyxU/HeEib3t6iUwIZ3/Q=";
        aarch64-linux = "sha256-gmQljaxIyz+ULd27y9BA8QNhabgwWzHlVZjCLXH3qew=";
      }
      .${stdenvNoCC.hostPlatform.system}
        or (throw "unsupported system ${stdenvNoCC.hostPlatform.system}");

  };

  postPatch = ''
    rm .bazelversion
  '';

  buildAttrs.installPhase = ''
    runHook preInstall

    install -Dm644 bazel-bin/tinkey_deploy.jar \
      --target-directory="$out"/share/java
    makeWrapper ${lib.getExe' jdk "java"} $out/bin/tinkey \
      --add-flags "-cp $out/share/java/tinkey_deploy.jar com.google.crypto.tink.tinkey.Tinkey"

    runHook postInstall
  '';

  meta = {
    description = "Command line tool for Tink";
    homepage = "https://github.com/tink-crypto/tink-tinkey";
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
    mainProgram = "tinkey";
    maintainers = with lib.maintainers; [ tbutter ];
  };
}
