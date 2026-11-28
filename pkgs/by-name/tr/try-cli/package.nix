{
  lib,
  stdenv,
  fetchFromGitHub,
  ruby,
  bash,
  makeBinaryWrapper,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "try-cli";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "tobi";
    repo = "try";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZSt6LSp0AQTbdN86lJGJPWcx6oFR63AFi4s8Vjr5a5o=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeBinaryWrapper ];
  buildInputs = [
    ruby
    bash
  ];

  postPatch = ''
    substituteInPlace try.rb \
      --replace-fail '/usr/bin/env ruby' '${lib.getExe ruby}' \
      --replace-fail '/usr/bin/env sh' '${lib.getExe' bash "sh"}'
  '';

  dontBuild = true;

  nativeCheckInputs = [ ruby ];
  doCheck = true;
  checkPhase = ''
    runHook preCheck
    # Detach stdio from the builder PTY (winsize 0x0 breaks TerminalEnvOverrideTest)
    RUBYOPT="-EUTF-8" rake unit </dev/null 2>&1 | cat
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/try
    install -Dm755 try.rb $out/share/try/try.rb
    cp -r lib $out/share/try/lib
    makeWrapper $out/share/try/try.rb $out/bin/try \
      --prefix PATH : ${lib.makeBinPath [ ruby ]}
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage experiment and worktree directories with fuzzy search";
    homepage = "https://github.com/tobi/try";
    changelog = "https://github.com/tobi/try/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.unix;
    mainProgram = "try";
  };
})
