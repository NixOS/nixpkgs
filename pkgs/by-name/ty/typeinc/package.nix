{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
  installShellFiles,
  versionCheckHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "typeinc";
  version = "1.0.3";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "Typeinc";
    tag = "v${version}";
    hash = "sha256-/R3mNxZE4Pt4UlCljsQphHBCoA2JIZrTorqU4Adcdp0=";
  };

  build-system = [ python3Packages.hatchling ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage docs/man/typeinc.1
  '';

  nativeCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal tool to test your typing speed with various difficulty levels";
    homepage = "https://github.com/AnirudhG07/Typeinc";
    mainProgram = "typeinc";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ lonerOrz ];
  };
}
