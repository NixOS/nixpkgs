{
  version,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "ufbt-unwrapped";
  inherit version;

  pyproject = true;

  src = fetchFromGitHub {
    owner = "flipperdevices";
    repo = "flipperzero-ufbt";
    rev = "v${version}";
    sha256 = "sha256-PhuUzw/szzPakxgDf/7DYiL7reMGoFrG4CiOa2bBGd4=";
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
}
