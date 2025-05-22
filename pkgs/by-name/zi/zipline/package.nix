{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_9,
  nodejs,
  makeWrapper,
  pkgs,
  ffmpeg,
  openssl,
  vips,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

let
  prisma-engines = pkgs.prisma-engines.overrideAttrs (
    finalAttrs: prevAttrs: {
      version = "6.5.0";
      src = fetchFromGitHub {
        inherit (prevAttrs.src) owner repo;
        rev = finalAttrs.version;
        hash = "sha256-m3LBIMIVMI5GlY0+QNw/nTlNWt2rGOZ28z+CfdP51cY=";
      };
      cargoHash = "sha256-yG+omKAS1eWq3sFgKXMoZWhTP4M34dVRes7OhhTUyTQ=";
      cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) pname version src;
        hash = finalAttrs.cargoHash;
      };
    }
  );

  environment = {
    NEXT_TELEMETRY_DISABLED = "1";
    FFMPEG_PATH = lib.getExe ffmpeg;
    FFPROBE_PATH = lib.getExe' ffmpeg "ffprobe";
    PRISMA_SCHEMA_ENGINE_BINARY = lib.getExe' prisma-engines "schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = lib.getExe' prisma-engines "query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines}/lib/libquery_engine.node";
    PRISMA_INTROSPECTION_ENGINE_BINARY = lib.getExe' prisma-engines "introspection-engine";
    PRISMA_FMT_BINARY = lib.getExe' prisma-engines "prisma-fmt";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "zipline";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "diced";
    repo = "zipline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-waUc2DzD7oQ/ZuPKvUwu3Yj6uxrZauR4phcQwh7YfKw=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Q1PHXoiqUorAGcpIvM5iBvPINLRv+dAo0awhG4gvsrI=";
  };

  buildInputs = [ vips ];

  nativeBuildInputs = [
    pnpm_9.configHook
    nodejs
    makeWrapper
  ];

  env = environment;

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/zipline}

    cp -r build node_modules prisma .next mimes.json code.json package.json $out/share/zipline

    mkBin() {
      makeWrapper ${lib.getExe nodejs} "$out/bin/$1" \
        --chdir "$out/share/zipline" \
        --set NODE_ENV production \
        --prefix PATH : ${lib.makeBinPath [ openssl ]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ openssl ]} \
        ${
          lib.concatStringsSep " " (
            lib.mapAttrsToList (name: value: "--set ${name} ${lib.escapeShellArg value}") environment
          )
        } \
        --add-flags "--enable-source-maps build/$2"
    }

    mkBin zipline server
    mkBin ziplinectl ctl

    runHook postInstall
  '';

  preFixup = ''
    find $out -name libvips-cpp.so.42 -print0 | while read -d $'\0' libvips; do
      echo replacing libvips at $libvips
      rm $libvips
      ln -s ${lib.getLib vips}/lib/libvips-cpp.so.42 $libvips
    done
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/ziplinectl";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    inherit prisma-engines;
    tests = { inherit (nixosTests) zipline; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "ShareX/file upload server that is easy to use, packed with features, and with an easy setup";
    changelog = "https://github.com/diced/zipline/releases/tag/v${finalAttrs.version}";
    homepage = "https://zipline.diced.sh/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "zipline";
  };
})
