{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, mashumaro
, orjson
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "open-meteo";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-open-meteo";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-IB+dfQ4bb4dMYYQUVH9YbP3arvfgt4SooPlOKP3AVI8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    mashumaro
    orjson
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
    "open_meteo"
  ];

  meta = with lib; {
    description = "Python client for the Open-Meteo API";
    homepage = "https://github.com/frenck/python-open-meteo";
    changelog = "https://github.com/frenck/python-open-meteo/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
