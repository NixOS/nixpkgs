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
    sha256 = "1wgk445gmi0x7xmd8qvnyxy1ka0n72fr6nrhzdm29q6687dqyi7h";
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

  meta = with lib; {
    description = "Unofficial python api for Erowid, PsychonautWiki and AskTheCaterpillar";
    homepage = "https://github.com/OpenJarbas/PySychonaut";
    maintainers = [ ];
    license = licenses.asl20;
  };
}
