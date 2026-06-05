{
  lib,
  arrow,
  beautifulsoup4,
  bibtexparser,
  buildPythonPackage,
  deprecated,
  fake-useragent,
  fetchFromGitHub,
  free-proxy,
  httpx,
  python-dotenv,
  requests,
  selenium,
  setuptools,
  sphinx-rtd-theme,
  stem,
  typing-extensions,
  wheel,
}:

buildPythonPackage rec {
  pname = "scholarly";
  version = "1.7.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scholarly-python-package";
    repo = "scholarly";
    tag = "v${version}";
    hash = "sha256-yvew63tGwSjwseHK7wDqm26xiyCztUzxMqBpwwLD798=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    arrow
    beautifulsoup4
    bibtexparser
    deprecated
    fake-useragent
    free-proxy
    httpx
    python-dotenv
    requests
    selenium
    sphinx-rtd-theme
    typing-extensions
  ];

  optional-dependencies = {
    tor = [ stem ];
  };

  nativeCheckInputs = lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "scholarly" ];

  meta = {
    description = "Retrieve author and publication information from Google Scholar";
    homepage = "https://scholarly.readthedocs.io/";
    changelog = "https://github.com/scholarly-python-package/scholarly/releases/tag/${src.tag}";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
