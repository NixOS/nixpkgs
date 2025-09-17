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

buildGoModule rec {
  pname = "wtfutil";
  version = "0.46.1";

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = "wtf";
    rev = "v${version}";
    sha256 = "sha256-GLLTI/hxlkt3OvtTWRNdzQ9jzO4xzJV9RruiJUyWD5g=";
  };

  vendorHash = "sha256-OSoQkBAx0kJKiKq0pRGrkkSowTynw/MJvYSdhd1Jt/k=";
  proxyVendor = true;

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace flags/flags.go --replace-fail 'version := "dev"' 'version := "v${version}"'
  '';

  postInstall = ''
    mv "$out/bin/wtf" "$out/bin/wtfutil"
    wrapProgram "$out/bin/wtfutil" --prefix PATH : "${ncurses.dev}/bin"
  '';

  doInstallCheck = true;
  # Darwin Error: mkdir /var/empty: file exists
  nativeInstallCheckInputs = lib.optional (!stdenv.hostPlatform.isDarwin) [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Personal information dashboard for your terminal";
    homepage = "https://wtfutil.com/";
    changelog = "https://github.com/wtfutil/wtf/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      kalbasit
    ];
    mainProgram = "wtfutil";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
