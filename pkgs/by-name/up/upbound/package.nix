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
    if "${version-channel}" == "main" then import ./sources-main.nix else import ./sources-stable.nix;
  arch = sources.archMap.${system};

in
stdenvNoCC.mkDerivation {
  pname = if "${version-channel}" == "main" then "upbound-main" else "upbound";
  version = sources.version;
  srcs = [
    (fetchurl {
      url = sources.fetchurlAttrSet.${system}.docker-credential-up.url;
      sha256 = sources.fetchurlAttrSet.${system}.docker-credential-up.hash;
    })

    (fetchurl {
      url = sources.fetchurlAttrSet.${system}.up.url;
      sha256 = sources.fetchurlAttrSet.${system}.up.hash;
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

  versionCheckProgramArg = "version";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doCheck = false;

  passthru.updateScript = [
    ./update.sh
    "${version-channel}"
  ];

  passthru.tests = {
    versionCheck = versionCheckHook;
  };

  meta = {
    description = "CLI for interacting with Upbound Cloud, Upbound Enterprise, and Universal Crossplane (UXP)";
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
