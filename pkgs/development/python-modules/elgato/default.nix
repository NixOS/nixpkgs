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
  pname = "elgato";
  version = "2.1.1";
  disabled = pythonOlder "3.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-elgato";
    rev = "v${version}";
    sha256 = "19z568jjyww7vi8s44anrb66qjz5l22nz4jqcz49ybhf22warmff";
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
    description = "Python client for Elgato Key Lights";
    homepage = "https://github.com/frenck/python-elgato";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
