{
  lib,
  stdenv,
  fetchFromGitHub,
  ruby,
  bash,
  makeBinaryWrapper,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "try-cli";
  version = "1.10.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tobi";
    repo = "try";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZSt6LSp0AQTbdN86lJGJPWcx6oFR63AFi4s8Vjr5a5o=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];
  buildInputs = [
    ruby
    bash
  ];

  postPatch = ''
    substituteInPlace try.rb \
      --replace-fail '/usr/bin/env ruby' '${ruby}/bin/ruby' \
      --replace-fail '/usr/bin/env sh' '${bash}/bin/sh'
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
  versionCheckProgramArg = "--help";
  doInstallCheck = true;

  meta = {
    description = "Manage experiment and worktree directories with fuzzy search";
    homepage = "https://github.com/tobi/try";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.unix;
    mainProgram = "try";
  };
})
