{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "telegram-delete-all-messages";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "pengwius";
    repo = "telegram-delete-all-messages";
    tag = "v${version}";
    hash = "sha256-fHizUv5klPzoLewwB0FuRxT4a5w6aPuMK7jZ65BeJ1c=";
  };

  propagatedBuildInputs = with python3Packages; [
    telethon
    cryptg
    qrcode
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
