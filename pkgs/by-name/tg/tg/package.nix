{
  lib,
  fetchFromGitHub,
  python3Packages,
  stdenv,
  libnotify,
}:

python3Packages.buildPythonApplication rec {
  pname = "tg";
  version = "0.22.0";
  pyproject = true;
  disabled = python3Packages.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "paul-nameless";
    repo = "tg";
    tag = "v${version}";
    hash = "sha256-qzqYkksocR86QFmP75ZE93kMSVmdel+OTxPgt9uZHLI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry-core>=1.0.0,<2.0.0" "poetry-core"
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    # Fix notifications on platforms other than darwin by providing notify-send
    sed -i 's|^NOTIFY_CMD = .*|NOTIFY_CMD = "${libnotify}/bin/notify-send {title} {message} -i {icon_path}"|' tg/config.py
  '';

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    mailcap-fix
    python-telegram
  ];

  doCheck = false; # No tests

  meta = {
    description = "Terminal client for telegram";
    mainProgram = "tg";
    homepage = "https://github.com/paul-nameless/tg";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
