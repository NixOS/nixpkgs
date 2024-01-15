{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
, pytest-asyncio
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "odp-amsterdam";
  version = "6.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-odp-amsterdam";
    rev = "refs/tags/v${version}";
    hash = "sha256-dAyKypc8bMWkXhYa7BlGGAGqPaPJHFHwXd/UK80BGoE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"0.0.0"' '"${version}"'
    sed -i '/addopts/d' pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pytz
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "odp_amsterdam"
  ];

  meta = with lib; {
    description = "Python client for getting garage occupancy in Amsterdam";
    homepage = "https://github.com/klaasnicolaas/python-odp-amsterdam";
    changelog = "https://github.com/klaasnicolaas/python-odp-amsterdam/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
