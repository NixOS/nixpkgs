{
  fetchFromGitHub,
  installShellFiles,
  lib,
  rustPlatform,
  scdoc,
}:

rustPlatform.buildRustPackage rec {
  pname = "uair";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "metent";
    repo = "uair";
    rev = "v${version}";
    hash = "sha256-VytbtTQch8O5hCg3L3ANNOfFOyiQY1V7DvGMEKr1R04=";
  };

  cargoHash = "sha256-5/CvyN/uOMIEhOg7uqon6bQd5EQDPVrfi7XnJF9mZyg=";

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  preFixup = ''
    scdoc < docs/uair.1.scd > docs/uair.1
    scdoc < docs/uair.5.scd > docs/uair.5
    scdoc < docs/uairctl.1.scd > docs/uairctl.1

    installManPage docs/*.[1-9]
  '';

  meta = with lib; {
    description = "Extensible pomodoro timer";
    homepage = "https://github.com/metent/uair";
    license = licenses.mit;
    maintainers = with maintainers; [ thled ];
  };
}
