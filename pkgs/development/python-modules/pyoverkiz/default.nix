{ lib
, aiohttp
, attrs
, backoff
, boto3
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pyhumps
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, warrant-lite
}:

buildPythonPackage rec {
  pname = "pyoverkiz";
  version = "1.5.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iMicknl";
    repo = "python-overkiz-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-8Xzrnt5W3kQf+kHHiAWimyw4uHc3UL9BsZePcAYKHNk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pyhumps = "^3.0.2,!=3.7.3"' 'pyhumps = "^3.0.2"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    attrs
    aiohttp
    backoff
    pyhumps
    boto3
    warrant-lite
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyoverkiz"
  ];

  meta = with lib; {
    description = "Module to interact with the Somfy TaHoma API or other OverKiz APIs";
    homepage = "https://github.com/iMicknl/python-overkiz-api";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
