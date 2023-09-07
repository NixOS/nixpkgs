{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, wheel
, xmltodict
}:

buildPythonPackage rec {
  pname = "aioruckus";
  version = "0.34";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "ms264556";
    repo = "aioruckus";
    rev = "refs/tags/v${version}";
    hash = "sha256-SPj1w1jAJFBsWj1+N8srAbvlh+yB3ZTT7aDcZTnmUto=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "setuptools>=68.1" "setuptools"
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
    xmltodict
  ];

  pythonImportsCheck = [
    "aioruckus"
  ];

  meta = with lib; {
    description = "Python client for Ruckus Unleashed and Ruckus ZoneDirector";
    homepage = "https://github.com/ms264556/aioruckus";
    license = licenses.bsd0;
    maintainers = with maintainers; [ fab ];
  };
}
