{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "cemm";
  version = "0.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-cemm";
    rev = "refs/tags/v${version}";
    hash = "sha256-BorgGHxoEeIGyJKqe9mFRDpcGHhi6/8IV7ubEI8yQE4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"0.0.0"' '"${version}"' \
      --replace 'addopts = "--cov"' ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cemm"
  ];

  meta = with lib; {
    description = "Module for interacting with CEMM devices";
    homepage = "https://github.com/klaasnicolaas/python-cemm";
    changelog = "https://github.com/klaasnicolaas/python-cemm/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
