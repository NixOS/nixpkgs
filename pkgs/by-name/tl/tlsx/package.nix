{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "tlsx";
  version = "1.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "tlsx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3klBmWQfp8PLF4/8bZjHCk+4hiUXX3E+izIfDG2FMfU=";
  };

  vendorHash = "sha256-5zqiA4Aoc5qjxXf8q+IzJqycSv49hJfynAVQ5Yomrro=";

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  ldflags = [ "-s" ];

  # Tests require network access
  doCheck = false;

  doInstallCheck = true;

  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TLS grabber focused on TLS based data collection";
    longDescription = ''
      A fast and configurable TLS grabber focused on TLS based data
      collection and analysis.
    '';
    homepage = "https://github.com/projectdiscovery/tlsx";
    changelog = "https://github.com/projectdiscovery/tlsx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
