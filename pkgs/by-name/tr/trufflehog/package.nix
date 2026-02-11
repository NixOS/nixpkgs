{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "trufflehog";
  version = "3.93.2";

  src = fetchFromGitHub {
    owner = "trufflesecurity";
    repo = "trufflehog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1tgbkpxvE7XuQMH9+1vP4cWKnJ+7i90GB+6u9hfi018=";
  };

  vendorHash = "sha256-U3pznVPh/nQ4YZ5y94VF+UeISXDaWJ/gTNrY8wqq2gQ=";

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
    license = with lib.licenses; [ agpl3Only ];
    maintainers = with lib.maintainers; [
      fab
      sarcasticadmin
    ];
    mainProgram = "trufflehog";
  };
})
