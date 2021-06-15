{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, poetry-core
, packaging
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "elgato";
  version = "2.1.1";
  disabled = pythonOlder "3.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-elgato";
    rev = "v${version}";
    sha256 = "sha256-ztWsuBAOLp/IZ1iSb4Wg5UtszMpWEaJR3IdzLyUy5ac=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  checkInputs = [
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

  pythonImportsCheck = [ "elgato" ];

  meta = with lib; {
    description = "Asynchronous Python client for Elgato Key Lights";
    homepage = "https://github.com/frenck/python-elgato";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
