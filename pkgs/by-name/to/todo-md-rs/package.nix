{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "todo-md-rs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "AimPizza";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-t/q00u3+3jr0T0RH+UCXjAovmxmLeVFljDgtKmhMczE=";
  };

  cargoHash = "sha256-0VYJ+jt8TEoK0E1V4IeJezPfSbbfuI2katvdh/XFfuo=";

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/todo help
  '';

  meta = with lib; {
    description = "Cli todo tool to interact with markdown files";
    homepage = "https://github.com/AimPizza/todo-md-rs";
    license = licenses.gpl3Plus;
    mainProgram = "todo";
    maintainers = with maintainers; [ aimpizza ];
  };
}
