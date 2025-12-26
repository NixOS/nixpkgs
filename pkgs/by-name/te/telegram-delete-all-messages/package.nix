{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "telegram-delete-all-messages";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "pengwius";
    repo = "telegram-delete-all-messages";
    tag = "v${version}";
    hash = "sha256-5Wx2FuG3EYC5WIaZyHB0lbVa9PZ/7uSSw3p3vZ9h+Io=";
  };

  propagatedBuildInputs = with python3Packages; [
    pyrogram
    tgcrypto
  ];

  doCheck = false;
  buildPhase = "true";

  format = "other";

  installPhase = ''
    runHook preInstall

    install -D cleaner.py $out/bin/${meta.mainProgram}

    runHook PostInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Delete your Telegram messages in supergroups";
    homepage = "https://github.com/pengwius/telegram-delete-all-messages";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pengwius ];
    mainProgram = "telegram-delete-all-messages";
  };
}
