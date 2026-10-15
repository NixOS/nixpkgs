{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  ncurses,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "wtfutil";
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = "wtf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kD3Fw8Qpl0tz8Kix0YDbGc/iM6CqgiGG+rEKjAEB4l0=";
  };

  vendorHash = "sha256-Or1l8Miq3PGwKzG8ZqupePSU/8SH5W6gfOcNrHEzWtA=";
  proxyVendor = true;

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace flags/flags.go \
      --replace-fail 'version := info.Main.Version' 'version := "v${finalAttrs.version}"' \
      --replace-fail 'var official bool' 'official := true'
  '';

  postInstall = ''
    mv "$out/bin/wtf" "$out/bin/wtfutil"
    wrapProgram "$out/bin/wtfutil" --prefix PATH : "${ncurses.dev}/bin"
  '';

  doInstallCheck = true;
  # Darwin Error: mkdir /var/empty: file exists
  nativeInstallCheckInputs = lib.optional (!stdenv.hostPlatform.isDarwin) versionCheckHook;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Personal information dashboard for your terminal";
    homepage = "https://wtfutil.com/";
    changelog = "https://github.com/wtfutil/wtf/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      kalbasit
    ];
    mainProgram = "wtfutil";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
