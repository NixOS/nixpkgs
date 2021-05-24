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
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "kennedyshead";
    repo = pname;
    rev = version;
    sha256 = "101d76zarvilzfmcy8n3bjqzyars8hsjzr0zc80d4rngv4vhrki1";
  };

  postPatch = ''
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
