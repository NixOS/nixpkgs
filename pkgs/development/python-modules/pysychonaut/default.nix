{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  requests-cache,
  beautifulsoup4,
}:

buildPythonPackage rec {
  pname = "pysychonaut";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "PySychonaut";
    inherit version;
    hash = "sha256-8ESP20HG4CRq+zBbk504FqgZfPd2Y9RqPx3E+goh8/E=";
  };

  preConfigure = ''
    substituteInPlace setup.py --replace-fail "bs4" "beautifulsoup4"
  '';

  build-system = [ setuptools ];

  dependencies = [
    requests
    requests-cache
    beautifulsoup4
  ];

  # No tests available
  doCheck = false;
  pythonImportsCheck = [ "pysychonaut" ];

  meta = {
    description = "Unofficial python api for Erowid, PsychonautWiki and AskTheCaterpillar";
    homepage = "https://github.com/OpenJarbas/PySychonaut";
    maintainers = [ ];
    license = lib.licenses.asl20;
  };
}
