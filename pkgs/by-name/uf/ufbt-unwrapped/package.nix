{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "ufbt-unwrapped";
  version = "0.2.6";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "flipperdevices";
    repo = "flipperzero-ufbt";
    rev = "v${version}";
    hash = "sha256-PhuUzw/szzPakxgDf/7DYiL7reMGoFrG4CiOa2bBGd4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools-git-versioning<2" "setuptools-git-versioning"
  '';

  build-system = with python3Packages; [
    setuptools
    setuptools-git-versioning
  ];

  dependencies = with python3Packages; [
    ansi
    oslex
  ];

  meta = {
    changelog = "https://github.com/flipperdevices/flipperzero-ufbt/releases/tag/v${version}";
    description = "Compact tool for building and debugging applications for Flipper Zero";
    homepage = "https://github.com/flipperdevices/flipperzero-ufbt";
    license = with lib.licenses; [
      gpl3
    ];
    maintainers = with lib.maintainers; [ mart-w ];
    mainProgram = "ufbt";
  };
}
