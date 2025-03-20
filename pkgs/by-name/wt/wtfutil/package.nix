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
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = "wtf";
    rev = "v${version}";
    sha256 = "sha256-DFrA4bx+wSOxmt1CVA1oNiYVmcWeW6wpfR5F1tnhyDY=";
  };

  vendorHash = "sha256-mQdKw3DeBEkCOtV2/B5lUIHv5EBp+8QSxpA13nFxESw=";
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

  meta = with lib; {
    description = "Personal information dashboard for your terminal";
    homepage = "https://wtfutil.com/";
    changelog = "https://github.com/wtfutil/wtf/raw/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      xiaoxiangmoe
      kalbasit
    ];
    mainProgram = "wtfutil";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
