{
  lib,
  stdenv,
  fetchFromGitHub,
  ruby,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "username-anarchy";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "urbanadventurer";
    repo = "username-anarchy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-46hl1ynA/nc2R70VHhOqbux6B2hwiJWs/sf0ZRwNFf0=";
  };

  buildInputs = [ ruby ];

  preInstall = ''
    mkdir -p $out/bin $out/lib
    install -Dm 555 format-plugins.rb $out/lib/
    install -Dm 555 username-anarchy $out/lib/

    ln -s $out/lib/username-anarchy $out/bin/username-anarchy
  '';

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/urbanadventurer/username-anarchy/";
    description = "Username generator tool for penetration testing";
    changelog = "https://github.com/adityatelange/evil-winrm-py/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      akechishiro
      letgamer
    ];
    platforms = lib.platforms.unix;
    mainProgram = "username-anarchy";
  };
})
