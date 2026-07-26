{
  lib,
  aiohttp,
  buildPythonPackage,
  colorlog,
  fetchFromGitHub,
  python-dateutil,
  requests,
  setuptools_80,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pyisy";
  version = "3.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "automicus";
    repo = "PyISY";
    tag = "v${version}";
    hash = "sha256-4mNG3dcDOuhRXSAN8FiKgxAdf7Yt04L+60luJ3FzKMQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'version_format="{tag}"' 'version="${version}"'
  '';

  build-system = [
    setuptools_80
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    colorlog
    python-dateutil
    requests
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyisy" ];

  meta = {
    description = "Python module to talk to ISY994 from UDI";
    homepage = "https://github.com/automicus/PyISY";
    changelog = "https://github.com/automicus/PyISY/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
