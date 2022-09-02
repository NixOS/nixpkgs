{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, inflection
, pyjwt
, pytest-asyncio
, pytestCheckHook
, python-dateutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-smarttub";
  version = "0.0.32";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mdz";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-3qAs0vL6YGFDsMFC3KAhSc/axxVOll/SOswaJgVi9Hc=";
  };

  propagatedBuildInputs = [
    aiohttp
    inflection
    pyjwt
    python-dateutil
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=legacy"
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyjwt~=2.1.0" "pyjwt>=2.1.0"
  '';

  pythonImportsCheck = [
    "smarttub"
  ];

  meta = with lib; {
    description = "Python API for SmartTub enabled hot tubs";
    homepage = "https://github.com/mdz/python-smarttub";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
