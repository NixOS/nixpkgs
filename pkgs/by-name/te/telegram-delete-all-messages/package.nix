{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "telegram-delete-all-messages";
  version = "0.0.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pengwius";
    repo = "telegram-delete-all-messages";
    tag = "v${version}";
    hash = "sha256-lcjE0q24qO72U/htxJvMncrU8o7qnP20MwqVRlChW5U=";
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

  meta = {
    description = "Delete your Telegram messages in supergroups";
    homepage = "https://github.com/pengwius/telegram-delete-all-messages";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pengwius ];
    mainProgram = "telegram-delete-all-messages";
  };
}
