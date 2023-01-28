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
  version = "4.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yh7gPyy3VMdyINBCZo5K2wA0BY7yYgHrKGZRB/pm77U=";
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

  disabledTestPaths = [
    # Tests are out-dated
    "ismartgate/tests/test_init.py"
  ];


  meta = with lib; {
    description = "Python module to work with the ismartgate and gogogate2 API";
    homepage = "https://github.com/bdraco/ismartgate";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
