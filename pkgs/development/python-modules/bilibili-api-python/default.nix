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
  pyjwt,
  pyyaml,
  qrcode,
  qrcode-terminal,
  rsa,
  setuptools,
  setuptools-scm,
  tqdm,
  yarl,
}:

buildPythonPackage rec {
  pname = "bilibili-api-python";
  version = "17.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "bilibili_api_python";
    inherit version;
    hash = "sha256-OWMQwYIP2TGkahDGEVIzviUOjbMVombupgjA9iXN8e8=";
  };

  # The upstream uses requirements.txt, which overly strict version constraints.
  pythonRelaxDeps = [
    "beautifulsoup4"
    "lxml"
    "pillow"
  ];

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
    apscheduler
    rsa
    pillow
    tqdm
    yarl
    pycryptodomex
    pyjwt
    qrcode-terminal
  ];

  # tests require network
  doCheck = false;

  pythonImportsCheck = [ "bilibili_api" ];

  meta = {
    changelog = "https://github.com/Nemo2011/bilibili-api/releases/tag/${version}";
    description = "Python module providing convenient integration for various Bilibili API along with some additional common features";
    homepage = "https://nemo2011.github.io/bilibili-api";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
