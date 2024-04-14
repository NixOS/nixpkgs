{ lib
, aiohttp
, aresponses
, awesomeversion
, backoff
, buildPythonPackage
, deepmerge
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "pyipp";
  version = "0.15.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
   owner = "ctalkington";
   repo = "python-ipp";
   rev = "refs/tags/${version}";
   hash = "sha256-k7NSCmugGov+lJXWeopUwKkGKL/EGhvxSSiby4CcmFM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace "--cov" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    awesomeversion
    backoff
    deepmerge
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "pyipp"
  ];

  meta = with lib; {
    changelog = "https://github.com/ctalkington/python-ipp/releases/tag/${version}";
    description = "Asynchronous Python client for Internet Printing Protocol (IPP)";
    homepage = "https://github.com/ctalkington/python-ipp";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
