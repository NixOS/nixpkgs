{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  libheif,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "timewall";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "bcyran";
    repo = "timewall";
    rev = version;
    hash = "sha256-B3pZCjl7Z78vAYYzceicwjmGfTbzYgrhpldUJnY8Aqs=";
  };

  cargoHash = "sha256-AYfRZyUitUgWIeDbg00RFbs+VLnIJFHrdpUcjDlkwE8=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ libheif ];

  SHELL_COMPLETIONS_DIR = "completions";

  preBuild = ''
    mkdir ${SHELL_COMPLETIONS_DIR}
  '';

  postInstall = ''
    installShellCompletion \
      --bash ${SHELL_COMPLETIONS_DIR}/timewall.bash \
      --zsh ${SHELL_COMPLETIONS_DIR}/_timewall \
      --fish ${SHELL_COMPLETIONS_DIR}/timewall.fish
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Apple dynamic HEIF wallpapers on GNU/Linux";
    homepage = "https://github.com/bcyran/timewall";
    changelog = "https://github.com/bcyran/timewall/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "timewall";
    maintainers = with lib.maintainers; [ bcyran ];
  };
}
