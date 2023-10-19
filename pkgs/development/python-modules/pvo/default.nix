{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pydantic
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "pvo";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-pvoutput";
    rev = "refs/tags/v${version}";
    hash = "sha256-6oVACUnK8WVlEx047CUXmSXQ0+M3xnSvyMHw5Wttk7M=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
      --replace "--cov" ""
  '';

  pythonImportsCheck = [
    "pvo"
  ];

  meta = with lib; {
    description = "Python module to interact with the PVOutput API";
    homepage = "https://github.com/frenck/python-pvoutput";
    changelog = "https://github.com/frenck/python-pvoutput/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
