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
  pname = "gridnet";
  version = "5.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-gridnet";
    rev = "refs/tags/v${version}";
    hash = "sha256-7tLT5sRoUjWs1DOIuUEbnJJkg9LHZqrN/eu+Mjx5Yd4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
      --replace "--cov" ""
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
    "gridnet"
  ];

  meta = with lib; {
    description = "Asynchronous Python client for NET2GRID devices";
    homepage = "https://github.com/klaasnicolaas/python-gridnet";
    changelog = "https://github.com/klaasnicolaas/python-gridnet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
