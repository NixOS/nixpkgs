{ lib
, aiohttp
, awesomeversion
, backoff
, buildPythonPackage
, pydantic
, fetchFromGitHub
, poetry-core
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "demetriek";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-demetriek";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-LCHHBcZgO9gw5jyaJiiS4lKyb0ut+PJvKTylIvIKHhc=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}" \
      --replace "--cov" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    awesomeversion
    backoff
    pydantic
    yarl
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "demetriek"
  ];

  meta = with lib; {
    description = "Python client for LaMetric TIME devices";
    homepage = "https://github.com/frenck/python-demetriek";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
