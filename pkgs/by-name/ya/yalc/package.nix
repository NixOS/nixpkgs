{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarnBuildHook,
  yarnConfigHook,
  npmHooks,
}:

stdenv.mkDerivation rec {
  pname = "yalc";
  version = "1.0.0-pre.54-unstable-2023-07-04";

  src = fetchFromGitHub {
    owner = "wclr";
    repo = "yalc";
    # Upstream has no tagged versions
    rev = "3b834e488837e87df47414fd9917c10f07f0df08";
    hash = "sha256-v8OhLVuRhnyN2PrslgVVS0r56wGhYYmjoz3ZUZ95xBc=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-+w3azJEnRx4v3nJ3rhpLWt6CjOFhMMmr1UL5hg2ZR48=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    npmHooks.npmInstallHook
    nodejs
  ];

  postInstall = ''
    substituteInPlace $out/bin/yalc \
      --replace-fail "/usr/bin/env node" "${lib.getExe nodejs}"
    chmod +x $out/libexec/yalc/deps/yalc/src/yalc.js
  '';

  meta = with lib; {
    description = "Framework for converting Left-To-Right (LTR) Cascading Style Sheets(CSS) to Right-To-Left (RTL)";
    mainProgram = "rtlcss";
    homepage = "https://rtlcss.com";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
