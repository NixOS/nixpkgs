{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  makeWrapper,
}:

buildGoModule rec {
  pname = "trufflehog";
  version = "3.90.8";

  src = fetchFromGitHub {
    owner = "trufflesecurity";
    repo = "trufflehog";
    tag = "v${version}";
    hash = "sha256-TF+nMpHTv67EIVtiNyJsGW14dN4zbp7OoO+tQeRPq+M=";
  };

  vendorHash = "sha256-BeC4W2oIWAFzZnKpwFh1s3c6riNXYHs3dV+UyD/FhJ8=";

  nativeBuildInputs = [ makeWrapper ];

  proxyVendor = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=${version}"
  ];

  # Test cases run git clone and require network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/{generate,snifftest}

    wrapProgram $out/bin/trufflehog --add-flags --no-update
  '';

  doInstallCheck = true;

  versionCheckProgramArg = "--version";

  meta = with lib; {
    description = "Find credentials all over the place";
    homepage = "https://github.com/trufflesecurity/trufflehog";
    changelog = "https://github.com/trufflesecurity/trufflehog/releases/tag/v${version}";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [
      fab
      sarcasticadmin
    ];
    mainProgram = "trufflehog";
  };
}
