{ lib
, aiohttp
, awesomeversion
, backoff
, buildPythonPackage
, pydantic
, fetchFromGitHub
, fetchpatch
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
    hash = "sha256-LCHHBcZgO9gw5jyaJiiS4lKyb0ut+PJvKTylIvIKHhc=";
  };

  patches = [
    # https://github.com/frenck/python-demetriek/pull/531
    (fetchpatch {
      name = "pydantic_2-compatibility.patch";
      url = "https://github.com/frenck/python-demetriek/commit/e677fe5b735b6b28572e3e5fd6aab56fc056f5e6.patch";
      excludes = [ "pyproject.toml" "poetry.lock" ];
      hash = "sha256-oMVR45KHDhcPId/0X9obJXCPE8s1gk5IgsGsgZesdZw=";
    })
  ];

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

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "demetriek"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python client for LaMetric TIME devices";
    homepage = "https://github.com/frenck/python-demetriek";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
