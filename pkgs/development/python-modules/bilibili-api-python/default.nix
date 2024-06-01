{
  aiohttp,
  apscheduler,
  beautifulsoup4,
  brotli,
  buildPythonPackage,
  colorama,
  fetchPypi,
  httpx,
  lib,
  lxml,
  pillow,
  pycryptodomex,
  pyyaml,
  qrcode,
  qrcode-terminal,
  requests,
  rsa,
  setuptools,
  setuptools-scm,
  tqdm,
  yarl,
}:
buildPythonPackage rec {
  pname = "bilibili-api-python";
  version = "16.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ecv9lzp2L13seBosahgnglaZP8YZCD/13nlTPP8LCs0=";
  };

  postPatch = ''
    # The upstream uses requirements.txt, which overly strict version constraints.
    substituteInPlace requirements.txt \
      --replace-fail "~=" ">="
  '';

  build-system = [
    setuptools-scm
    setuptools
  ];

  dependencies = [
    aiohttp
    beautifulsoup4
    colorama
    lxml
    pyyaml
    brotli
    httpx
    qrcode
    requests
    apscheduler
    rsa
    pillow
    tqdm
    yarl
    pycryptodomex
    qrcode-terminal
  ];

  # tests require network
  doCheck = false;

  pythonImportsCheck = [ "bilibili_api" ];

  meta = {
    changelog = "https://github.com/Nemo2011/bilibili-api/releases/tag/${version}";
    description = "A python module providing convenient integration for various Bilibili API along with some additional common features";
    homepage = "https://nemo2011.github.io/bilibili-api";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
