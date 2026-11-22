{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  hatchling,
  httpx,
  httpxthrottlecache,
  humanize,
  jinja2,
  lxml,
  nest-asyncio,
  orjson,
  pandas,
  pyarrow,
  pydantic,
  pyrate-limiter,
  rank-bm25,
  rapidfuzz,
  rich,
  stamina,
  tabulate,
  textdistance,
  tqdm,
  truststore,
  unidecode,
}:

buildPythonPackage (finalAttrs: {
  pname = "edgartools";
  version = "5.62.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dgunning";
    repo = "edgartools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Af3XXWTpi51CFh9Zn9gY/MF1CuystG1fT8VQupD3s5w=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "certifi" ];

  dependencies = [
    beautifulsoup4
    certifi
    httpx
    httpxthrottlecache
    humanize
    jinja2
    lxml
    nest-asyncio
    orjson
    pandas
    pyarrow
    pydantic
    pyrate-limiter
    rank-bm25
    rapidfuzz
    rich
    stamina
    tabulate
    textdistance
    tqdm
    truststore
    unidecode
  ];

  # Importing `edgar` creates ~/.edgar; give the check a writable HOME.
  preInstallCheck = ''
    export HOME="$TMPDIR"
  '';

  pythonImportsCheck = [ "edgar" ];

  meta = {
    description = "Python library for accessing SEC EDGAR filings";
    homepage = "https://github.com/dgunning/edgartools";
    changelog = "https://github.com/dgunning/edgartools/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
})
