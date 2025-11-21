{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  versionCheckHook,
  nix-update-script,
  pkg-config,
  libusb1,
  libnfc,
}:

buildGoModule (finalAttrs: {
  pname = "zaparoo";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "ZaparooProject";
    repo = "zaparoo-core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U/MNK8K7XAEuIa06mjJdUJRKHUFWqH7BFhAgJCbdj/s=";
  };

  vendorHash = "sha256-UTMYZ8la4VsxIVjcRg8l1yGy52CRjv/6WZQgHJ+oFdE=";

  webUIVersion = "1.8.0";
  webUI = fetchurl {
    url = "https://github.com/ZaparooProject/zaparoo-app/releases/download/v${finalAttrs.webUIVersion}/zaparoo_app-web-${finalAttrs.webUIVersion}.tar.gz";
    hash = "sha256-77QyMFbx73vaKIRDCnhdqDXBb8MfQSsCWghe3XEL0tk=";
  };

  subPackages = [ "cmd/linux" ];

  tags = [
    "netgo"
    "osusergo"
    "sqlite_omit_load_extension"
  ];

  ldflags = [
    "-s"
    "-X github.com/ZaparooProject/zaparoo-core/pkg/config.AppVersion=${finalAttrs.version}"
  ];

  env.CGO_ENABLED = 1;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb1
    libnfc
  ];

  postPatch = ''
    mkdir -p pkg/assets/_app/dist
    tar xf ${finalAttrs.webUI} -C pkg/assets/_app/dist/
  '';

  postInstall = ''
    mv $out/bin/linux $out/bin/zaparoo
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Launch games and cores on your MiSTer, emulators and handhelds using NFC tags or cards";
    homepage = "https://zaparoo.org/";
    changelog = "https://github.com/ZaparooProject/zaparoo-core/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "zaparoo";
  };
})
