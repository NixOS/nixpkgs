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
  version = "0.0.27";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mdz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EoZn5yxj18hi4oEMuUcB5UN2xQFkLbSG/awp+Qh029E=";
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

  postPatch = ''
    substituteInPlace setup.py \
      --replace "aiohttp~=3.7.3" "aiohttp>=3.7.4,<4"
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
