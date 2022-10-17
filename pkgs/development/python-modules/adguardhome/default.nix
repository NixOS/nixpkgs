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
  pname = "adguardhome";
  version = "0.5.1";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "sha256-HAgt52Bo2NOUkpr5xvWTcRyrLKpfcBDlVAZxgDNI7hY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov" "" \
      --replace '"0.0.0"' '"${version}"'

    substituteInPlace tests/test_adguardhome.py \
      --replace 0.0.0 ${version}
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "adguardhome" ];

  meta = with lib; {
    description = "Python client for the AdGuard Home API";
    homepage = "https://github.com/frenck/python-adguardhome";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
