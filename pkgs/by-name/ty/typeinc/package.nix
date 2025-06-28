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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "AnirudhG07";
    repo = "Typeinc";
    tag = "v${version}";
    hash = "sha256-p549vz4PoZgFybu/X/6BZfEnQAeQEA1jZAgqB5nD5UM=";
  };

  pyproject = true;
  build-system = [ python3Packages.hatchling ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = with python3Packages; [
    setuptools
    pyttsx3
    pyperclip
    keyboard
  ];

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
