{
  lib,
  fetchurl,
  installShellFiles,
  versionCheckHook,
  stdenvNoCC,
  version-channel ? "stable",
}:
let
  inherit (stdenvNoCC.hostPlatform) system;
  sources =
    if "${version-channel}" == "main" then
      lib.importJSON ./sources-main.json
    else
      lib.importJSON ./sources-stable.json;
  arch = sources.archMap.${system};

in
stdenvNoCC.mkDerivation {
  pname = if "${version-channel}" == "main" then "upbound-main" else "upbound";
  version = sources.version;
  srcs = [
    (fetchurl {
      url = sources.fetchurlAttrSet.docker-credential-up.${system}.url;
      sha256 = sources.fetchurlAttrSet.docker-credential-up.${system}.hash;
    })

    (fetchurl {
      url = sources.fetchurlAttrSet.up.${system}.url;
      sha256 = sources.fetchurlAttrSet.up.${system}.hash;
    })
  ];

  sourceRoot = ".";

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    cp ./${arch}/up $out/bin/up
    chmod +x $out/bin/up

    cp ./${arch}/docker-credential-up $out/bin/docker-credential-up
    chmod +x $out/bin/docker-credential-up

    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --bash --name up <(echo complete -C up up)
  '';

  # FIXME: error when running `env -i up`:
  # "up: error: $HOME is not defined"
  doInstallCheck = false;
  versionCheckProgram = "${placeholder "out"}/bin/up";
  versionCheckProgramArg = "version";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doCheck = false;

  passthru.updateScript = [
    ./update
    "${version-channel}"
  ];

  meta = {
    description = "CLI for interacting with Upbound Cloud, Upbound Enterprise, and Universal Crossplane (UXP)";
    changelog = "https://docs.upbound.io/reference/cli/rel-notes/#whats-changed";
    homepage = "https://upbound.io";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      lucperkins
      jljox
    ];
    mainProgram = "up";
    platforms = sources.platformList;
  };
}
