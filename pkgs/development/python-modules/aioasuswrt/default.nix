{ lib
, asyncssh
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aioasuswrt";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "kennedyshead";
    repo = pname;
    rev = "V${version}";
    sha256 = "1iv9f22v834g8wrjcynjn2azpzk8gsczv71jf7dw8aix0n04h325";
  };

  propagatedBuildInputs = [
    asyncssh
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov-report html" "" \
      --replace "--cov-report term-missing" ""
  '';

  pythonImportsCheck = [
    "aioasuswrt"
  ];

  meta = with lib; {
    description = "Python module for Asuswrt";
    homepage = "https://github.com/kennedyshead/aioasuswrt";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
