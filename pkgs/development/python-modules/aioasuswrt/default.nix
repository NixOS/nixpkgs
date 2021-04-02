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
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "kennedyshead";
    repo = pname;
    rev = "V${version}";
    sha256 = "1h1qwc7szgrcwiz4q6x4mlf26is20lj1ds5rcb9i611j26656v6d";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "cryptography==3.3.2" "cryptography"
    substituteInPlace setup.cfg \
      --replace "--cov-report html" "" \
      --replace "--cov-report term-missing" ""
  '';

  propagatedBuildInputs = [ asyncssh ];

  checkInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioasuswrt" ];

  meta = with lib; {
    description = "Python module for Asuswrt";
    homepage = "https://github.com/kennedyshead/aioasuswrt";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
