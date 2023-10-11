{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, freezegun
, orjson
, pydevccu
, pytest-aiohttp
, pytestCheckHook
, python-slugify
, pythonOlder
, setuptools
, voluptuous
, websocket-client
, xmltodict
, wheel
}:

buildPythonPackage rec {
  pname = "hahomematic";
  version = "2023.10.7";
  format = "pyproject";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-m7jBL4qB8ZcGifd6F2/In8JrSMyFeEYKf52Y+y22yK0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "setuptools~=68.2" "setuptools" \
      --replace "wheel~=0.41.2" "wheel"
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
    orjson
    python-slugify
    voluptuous
  ];

  nativeCheckInputs = [
    freezegun
    pydevccu
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hahomematic"
  ];

  meta = with lib; {
    description = "Python module to interact with HomeMatic devices";
    homepage = "https://github.com/danielperna84/hahomematic";
    changelog = "https://github.com/danielperna84/hahomematic/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
