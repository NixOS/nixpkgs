{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytest-aiohttp
, poetry-core
, pytest-asyncio
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyairnow";
  version = "1.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "asymworks";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-aab+3xrEiCjysa+DzXWelQwz8V2tr74y8v0NpDZiuTk=";
  };

  patches = [
    (fetchpatch {
      # remove setuptools, wheel from build-system requirements
      # https://github.com/asymworks/pyairnow/pull/7
      name = "pyairnow-build-system.patch";
      url = "https://github.com/asymworks/pyairnow/commit/e3cc892ffce855d8213264248b6b4ed78ee791bd.patch";
      hash = "sha256-L0MV2okkf6Nf1S4zS7lb4lt5eSfTF10yDJLzpyDrSl8=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-aiohttp
    pytest-cov
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyairnow" ];

  meta = with lib; {
    description = "Python wrapper for EPA AirNow Air Quality API";
    homepage = "https://github.com/asymworks/pyairnow";
    changelog = "https://github.com/asymworks/pyairnow/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
