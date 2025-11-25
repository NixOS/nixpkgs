{
  lib,
  aiohttp,
  buildPythonPackage,
  colorlog,
  fetchFromGitHub,
  python-dateutil,
  requests,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pyisy";
  version = "3.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "automicus";
    repo = "PyISY";
    tag = "v${version}";
    hash = "sha256-9gGrrFh5xCuX4GjF6a6RRGkpF/rH07Zz0nyKvgwgEkU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'version_format="{tag}"' 'version="${version}"'
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    aiohttp
    colorlog
    python-dateutil
    requests
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pyisy" ];

  meta = with lib; {
    description = "Python module to talk to ISY994 from UDI";
    homepage = "https://github.com/automicus/PyISY";
    changelog = "https://github.com/automicus/PyISY/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
