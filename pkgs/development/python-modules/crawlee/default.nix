{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  setuptools,
  apify-fingerprint-datapoints,
  browserforge,
  cachetools,
  cookiecutter,
  colorama,
  eval-type-backport,
  httpx,
  impit,
  inquirer,
  more-itertools,
  protego,
  psutil,
  pydantic,
  pydantic-settings,
  pyee,
  snapshot-restore-py,
  sortedcollections,
  sortedcontainers,
  tldextract,
  typer,
  typing-extensions,
  yarl,

}:

buildPythonPackage rec {
  pname = "crawlee";
  version = "1.0.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UitSwTYtEWuVuoWCD4cAFxPykKPsaQVorbhipLKdfKQ=";
  };

  nativeBuildInputs = [
    hatchling
    setuptools
  ];

  propagatedBuildInputs = [
    apify-fingerprint-datapoints
    browserforge
    cachetools
    cookiecutter
    colorama
    eval-type-backport
    httpx
    impit
    inquirer
    more-itertools
    protego
    psutil
    pydantic
    pydantic-settings
    pyee
    snapshot-restore-py
    sortedcollections
    sortedcontainers
    tldextract
    typer
    typing-extensions
    yarl
  ];

  # Prevent byte-compiling the non-Python template files.
  # The path is relative to the site-packages directory.
  dontByteCompile = [
    "crawlee/project_template"
  ];

  pythonImportsCheck = [ "crawlee" ];

  meta = with lib; {
    description = "A web scraping and browser automation library for Python";
    homepage = "https://crawlee.dev/python";
    license = licenses.asl20;
    maintainers = with maintainers; [ monk3yd ];
  };
}
