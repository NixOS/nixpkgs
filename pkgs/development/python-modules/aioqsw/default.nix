{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "aioqsw";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-xXbOIG9gw1rO+iWdXNWWmweM83FpTLMuaDTcRZoMvL8=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioqsw" ];

  meta = with lib; {
    description = "Library to fetch data from QNAP QSW switches";
    homepage = "https://github.com/Noltari/aioqsw";
    changelog = "https://github.com/Noltari/aioqsw/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
