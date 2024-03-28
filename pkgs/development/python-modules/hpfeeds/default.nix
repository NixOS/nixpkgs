{
  lib,
  buildPythonPackage,
  fetchPypi,
  # deps
  aiohttp,
  aiorun,
  async-timeout,
  attrs,
  chardet,
  idna,
  idna-ssl,
  multidict,
  prometheus-client,
  yarl,
  wrapt,
  ...
}:

buildPythonPackage rec {
  pname = "hpfeeds";
  version = "3.1.0";
  format = "wheel";

  src = fetchPypi rec {
    inherit pname version format;
    hash = "sha256-lI18P8b/8yu3/9t6Jop5usAvc+xlpIaRYwDv5ipDI/o=";
    dist = python;
    python = "py2.py3";
  };

  propagatedBuildInputs = [
    aiohttp
    aiorun
    async-timeout
    attrs
    chardet
    idna
    idna-ssl
    multidict
    prometheus-client
    yarl
    wrapt
  ];

  meta = {
    description = "Honeynet Project generic authenticated datafeed protocol";
    homepage = "https://github.com/hpfeeds/hpfeeds";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ purefns ];
  };
}
