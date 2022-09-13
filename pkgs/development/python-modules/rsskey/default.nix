{ lib
, buildPythonPackage
, fetchPypi
, feedparser
, httpx
, loca
, markdownify
, trio
}:

buildPythonPackage rec {
  pname = "rsskey";
  version = "0.2.0";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QedLuwd0ES2LWhZ72Cjh3+ZZ7HbRyNsyLN9lNFbY5dQ=";
  };

  propagatedBuildInputs = [
    feedparser
    httpx
    loca
    markdownify
    trio
  ];

  doCheck = false; # upstream has no test
  pythonImportsCheck = [ "rsskey" ];

  meta = with lib; {
    description = "RSS feed mirror on Misskey";
    homepage = "https://sr.ht/~cnx/rsskey";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ McSinyx ];
  };
}
