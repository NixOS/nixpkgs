{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "webcomix";
  version = "3.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "J-CPelletier";
    repo = "webcomix";
    rev = version;
    hash = "sha256-Y16+/9TnECMkppgI/BeAbTLWt0M4V/xn1+hM4ILp/+g=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry>=1.2.0" poetry-core \
      --replace-fail "poetry.masonry.api" "poetry.core.masonry.api" \
      --replace-fail 'pytest-rerunfailures = "^11.1.2"' 'pytest-rerunfailures = "14.0"'
  '';

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = with python3Packages; [
    click
    tqdm
    scrapy
    scrapy-splash
    scrapy-fake-useragent
    pytest-rerunfailures
    docker
  ];

  pythonRelaxDeps = [
    "pytest-rerunfailures"
  ];

  doCheck = false;

  meta = {
    description = "Webcomic downloader";
    homepage = "https://github.com/J-CPelletier/webcomix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ CaptainJawZ ];
    mainProgram = "webcomix";
  };
}
