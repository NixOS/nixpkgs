{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "trufflehog";
  version = "3.96.0";

  src = fetchFromGitHub {
    owner = "trufflesecurity";
    repo = "trufflehog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4KsgBDQj2S6J+RT913bthuKIYLX8X+Jz4B0wYJB96Zg=";
  };

  vendorHash = "sha256-QHs0ilr/dq6WvtTi7JUIZPZsdUj8BPxR2n4htbYQYS8=";

  nativeBuildInputs = [ makeWrapper ];

  proxyVendor = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=${finalAttrs.version}"
  ];

  # Test cases run git clone and require network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/{generate,snifftest}

    wrapProgram $out/bin/trufflehog --add-flags --no-update
  '';

  doInstallCheck = true;

  meta = {
    description = "Find credentials all over the place";
    homepage = "https://github.com/trufflesecurity/trufflehog";
    changelog = "https://github.com/trufflesecurity/trufflehog/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      fab
      sarcasticadmin
    ];
    mainProgram = "trufflehog";
  };
})
