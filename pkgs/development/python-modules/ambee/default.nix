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
  version = "0.4.0";
  disabled = pythonOlder "3.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-ambee";
    rev = "v${version}";
    sha256 = "07n3fxkr7s4aasbgh8q5yh2qx3b0wsh5p3q1v1qdb4gsp84gc1fv";
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
