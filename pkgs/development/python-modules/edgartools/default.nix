{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  certifi,
  fetchPypi,
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

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ToxP6B9rgtAaaySnCdT1/hZfRxxnFgLZJMc5awclNAg=";
  };

  build-system = [ hatchling ];

  # nixpkgs ships an older certifi than upstream's floor; edgartools only uses
  # it through httpx's default CA bundle.
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
