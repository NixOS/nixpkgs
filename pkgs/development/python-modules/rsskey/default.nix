{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  feedparser,
  httpx,
  loca,
  markdownify,
  trio,
}:

buildPythonPackage rec {
  pname = "rsskey";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QedLuwd0ES2LWhZ72Cjh3+ZZ7HbRyNsyLN9lNFbY5dQ=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    feedparser
    httpx
    loca
    markdownify
    trio
  ];

  doCheck = false; # upstream has no test
  pythonImportsCheck = [ "rsskey" ];

  meta = {
    description = "RSS feed mirror on Misskey";
    homepage = "https://sr.ht/~cnx/rsskey";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ McSinyx ];
  };
}
