{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "tfproviderdocs";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "bflad";
    repo = "tfproviderdocs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KCkohIGkh6sg/e0qBi90hMqh/XQQNCBF6Di6V2gxqak=";
  };

  vendorHash = "sha256-fSb1C2W29zF6ygiIg6iq19A4B6ensZLqyPD5MhQ5ec8=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/bflad/tfproviderdocs/version.Version=${finalAttrs.version}"
    "-X github.com/bflad/tfproviderdocs/version.VersionPrerelease="
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "version";

  meta = {
    description = "Terraform Provider Documentation Tool";
    license = lib.licenses.mpl20;
    longDescription = ''
      tfproviderdocs is an open-source tool for validating the documentation of Terraform providers.
      It automates the checking of documentation based on the provider's code specifications and configurations.
      This helps developers maintain consistent and up-to-date documentation.
    '';
    homepage = "https://github.com/bflad/tfproviderdocs";
    maintainers = with lib.maintainers; [ tembleking ];
    mainProgram = "tfproviderdocs";
  };
})
