{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  requests,
  beautifulsoup4,
  tabulate,
  iso8601,
  httpx,
}:

buildPythonPackage rec {
  pname = "doujinshi-dl-nhentai";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RicterZ";
    repo = "doujinshi-dl-nhentai";
    tag = "v${version}";
    hash = "sha256-PNUbl7ovl9VLAnasWG1Us6Ur68HOxLRgaWzKRzuyz3k=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    requests
    beautifulsoup4
    tabulate
    iso8601
    httpx
  ];

  pythonRemoveDeps = [
    "doujinshi-dl"
  ];

  doCheck = false;

  meta = {
    description = "nhentai plugin for doujinshi-dl";
    homepage = "https://github.com/RicterZ/doujinshi-dl-nhentai";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
