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
  version = "1.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "asymworks";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hkpfl8rdwyzqrr1drqlmcw3xpv3pi1jf19h1divspbzwarqxs1c";
  };

  patches = [
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/asymworks/pyairnow/commit/f7a01733a41c648563fc2fe4b559f61ef08b9153.patch";
      hash = "sha256-lcHnFP3bwkPTi9Zq1dZtShLKyXcxO0XoDF+PgjbWOqs=";
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
