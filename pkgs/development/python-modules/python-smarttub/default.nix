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
  version = "0.0.30";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mdz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PzmE0j/sas1Dc/U022dS3krROm292xJlL37+EWPEs+g=";
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
