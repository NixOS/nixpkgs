{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-yate";
  version = "0.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "eventphone";
    repo = "python-yate";
    rev = "refs/tags/v${version}";
    hash = "sha256-AdnlNsEOFuzuGTBmfV9zKyv2iFHEJ4eLMrC6SHHf7m0=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "yate"
  ];

  meta = with lib; {
    description = "Python library for the yate telephony engine";
    homepage = "https://github.com/eventphone/python-yate";
    changelog = "https://github.com/eventphone/python-yate/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ clerie ];
  };
}
