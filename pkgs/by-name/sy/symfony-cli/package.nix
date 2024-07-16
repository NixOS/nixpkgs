{ buildGoModule
, fetchFromGitHub
, lib
, nix-update-script
, nssTools
, makeBinaryWrapper
, versionCheckHook
}:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.9.1";
  vendorHash = "sha256-oo4lLJTF44hBb8QaIMONj+2WRdDSlhImZaC/nniWAhs=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    hash = "sha256-uJbX1IzZtcXH7mZuqh2YZy9wYZHNWfUHRZ8Tlm5zEac=";
    leaveDotGit = true;
    postFetch = ''
      git --git-dir $out/.git log -1 --pretty=%cd --date=format:'%Y-%m-%dT%H:%M:%SZ' > $out/SOURCE_DATE
      rm -rf $out/.git
    '';
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.channel=stable"
  ];

  preBuild = ''
    ldflags+=" -X main.buildDate=$(cat SOURCE_DATE)"
  '';

  buildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    mkdir $out/libexec
    mv $out/bin/symfony-cli $out/libexec/symfony

    makeBinaryWrapper $out/libexec/symfony $out/bin/symfony \
      --prefix PATH : ${lib.makeBinPath [ nssTools ]}
  '';

  # Tests requires network access
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  versionCheckProgram = "${placeholder "out"}/bin/symfony";
  versionCheckProgramArg = "version --no-ansi";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/symfony-cli/symfony-cli/releases/tag/v${version}";
    description = "Symfony CLI";
    homepage = "https://github.com/symfony-cli/symfony-cli";
    license = lib.licenses.agpl3Plus;
    mainProgram = "symfony";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
