{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, poetry-core
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ambee";
  version = "0.2.1";
  disabled = pythonOlder "3.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-ambee";
    rev = "v${version}";
    sha256 = "11liw2206lyrnx09giqapjpi25lr2qnbmigi6rgynr2a1i9vxy1s";
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

  pythonImportsCheck = [ "ambee" ];

  meta = with lib; {
    description = "Python client for Ambee API";
    homepage = "https://github.com/frenck/python-ambee";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
