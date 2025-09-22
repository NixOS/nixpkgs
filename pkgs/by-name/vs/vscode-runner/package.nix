{
  lib,
  fetchFromGitHub,
  buildDartApplication,
  kdePackages,
  sqlite,
}:

let
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "Merrit";
    repo = "vscode-runner";
    rev = "v${version}";
    hash = "sha256-ZzAQeSUFbHp2Bwiwsq8kgQqqNlr6hfXuz7PNAOSiBhU=";
  };
in
buildDartApplication {
  pname = "vscode-runner";
  inherit version src;

  vendorHash = "sha256-jS4jH00uxZIX81sZQIi+s42ofmXpD4/tPMRV2heaM2U=";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  dartEntryPoints = {
    "bin/vscode_runner" = "bin/vscode_runner.dart";
  };

  buildInputs = [ sqlite ];

  postInstall = ''
    substituteInPlace ./package/codes.merritt.vscode_runner.service \
      --replace-fail "Exec=" "Exec=$out/bin/vscode_runner"
    install -D \
      ./package/codes.merritt.vscode_runner.service \
      $out/share/dbus-1/services/codes.merritt.vscode_runner.service

    install -D \
      ./package/plasma-runner-vscode_runner.desktop \
      $out/share/krunner/dbusplugins/plasma-runner-vscode_runner.desktop
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "KRunner plugin for quickly opening recent VSCode workspaces";
    homepage = "https://github.com/Merrit/vscode-runner";
    changelog = "https://github.com/Merrit/vscode-runner/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.pinage404 ];
    mainProgram = "vscode_runner";
    inherit (kdePackages.krunner.meta) platforms;
  };
}
