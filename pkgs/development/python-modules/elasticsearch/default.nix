{ lib
, buildPythonPackage
, fetchFromGitHub

# docs
, sphinx-rtd-theme
, sphinxHook

# propagates
, elastic-transport

# extras
, aiohttp
, requests

# tests
, numpy
, pandas
, pytest-asyncio
, pytestCheckHook
, python-dateutil
, pyyaml
}:

buildPythonPackage (rec {
  pname = "elasticsearch";
  version = "8.4.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "elasticsearch-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-OjgfqEcKQH8ESvkcr2Ue2Q7KW2ykfrZccxm8kxzOClU=";
  };

  postPatch = ''
    sed -i '/addopts/d' setup.cfg
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    sphinx-rtd-theme
    sphinxHook
  ];

  sphinxRoot = "docs/sphinx";

  propagatedBuildInputs = [
    elastic-transport
  ];

  passthru.optional-dependencies = {
    async = [ aiohttp ];
    requests = [ requests ];
  };

  checkInputs = [
    numpy
    pandas
    pytest-asyncio
    pytestCheckHook
    python-dateutil
    pyyaml
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  meta = with lib; {
    changelog = "https://github.com/elastic/elasticsearch-py/releases/tag/v${version}";
    description = "Official low-level client for Elasticsearch";
    homepage = "https://github.com/elasticsearch/elasticsearch-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
})
