{ lib
, asynctest
, buildPythonPackage
, click
, defusedxml
, dicttoxml
, fetchFromGitHub
, httpx
, pycryptodome
, pytest-asyncio
, pytest-raises
, pytestCheckHook
, pythonOlder
, respx
, typing-extensions
}:

buildPythonPackage rec {
  pname = "ismartgate";
  version = "5.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-o2yzMxrF0WB6MbeL1Tuf0Sq4wS4FDIWZZx1x2rvwLmY=";
  };

  propagatedBuildInputs = [
    click
    defusedxml
    dicttoxml
    httpx
    pycryptodome
    typing-extensions
  ];

  nativeCheckInputs = [
    asynctest
    pytest-asyncio
    pytest-raises
    pytestCheckHook
    respx
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner>=5.2",' ""
  '';

  pythonImportsCheck = [
    "ismartgate"
  ];

  meta = with lib; {
    description = "Python module to work with the ismartgate and gogogate2 API";
    homepage = "https://github.com/bdraco/ismartgate";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
