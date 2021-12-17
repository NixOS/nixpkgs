{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, requests-mock
, pythonOlder
, pytest-asyncio
, pytestCheckHook
, python-dateutil
, requests
}:

buildPythonPackage rec {
  pname = "flipr-api";
  version = "1.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cnico";
    repo = pname;
    rev = version;
    sha256 = "00qkzr2g38fpa7ndnbfx9m4d50lmz0j74nkxif3amnkbl4m6l5vn";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    python-dateutil
    requests
  ];

  checkInputs = [
    requests-mock
    pytest-asyncio
    pytestCheckHook
  ];

  patches = [
    # Switch to poetry-core, https://github.com/cnico/flipr-api/pull/4
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/cnico/flipr-api/commit/f14be1dfd4f46d4d43d9ea47e51cafca3cc18e86.patch";
      sha256 = "1fdi19cq21zcjx4g132k480yhi5y0x5qj2l0h8k5zky5cdxs58r6";
    })
  ];

  pythonImportsCheck = [ "flipr_api" ];

  meta = with lib; {
    description = "Python client for Flipr API";
    homepage = "https://github.com/cnico/flipr-api";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
