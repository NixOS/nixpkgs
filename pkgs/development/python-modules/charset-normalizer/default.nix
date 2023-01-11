{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder

  # popular downstream dependencies
, aiohttp
, requests
}:

buildPythonPackage rec {
  pname = "charset-normalizer";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "Ousret";
    repo = "charset_normalizer";
    rev = "refs/tags/${version}";
    hash = "sha256-ntNMHjkQJqzSElEeyFmPIjUh6ZxQkTktPipfPHiJ/Vc=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=charset_normalizer --cov-report=term-missing" ""
  '';

  pythonImportsCheck = [
    "charset_normalizer"
  ];

  passthru.tests = { inherit aiohttp requests; };

  meta = with lib; {
    description = "Python module for encoding and language detection";
    homepage = "https://charset-normalizer.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
