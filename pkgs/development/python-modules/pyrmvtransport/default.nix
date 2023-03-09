{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, flit
, async-timeout
, lxml
, httpx
, pytestCheckHook
, pytest-asyncio
, pytest-httpx
}:

buildPythonPackage rec {
  pname = "pyrmvtransport";
  version = "0.3.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "cgtobi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nFxGEyO+wyRzPayjjv8WNIJ+XIWbVn0dyyjQKHiyr40=";
  };

  nativeBuildInputs = [
    flit
  ];

  propagatedBuildInputs = [
    async-timeout
    httpx
    lxml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-httpx
  ];

  patches = [
    # Can be removed with next release, https://github.com/cgtobi/PyRMVtransport/pull/55
    (fetchpatch {
      name = "update-tests.patch";
      url = "https://github.com/cgtobi/PyRMVtransport/commit/fe93b3d9d625f9ccf8eb7b0c39e0ff41c72d2e77.patch";
      sha256 = "sha256-t+GP5VG1S86vVSsisl85ZHBtOqxIi7QS83DA+HgRet4=";
    })
  ];

  pythonImportsCheck = [
    "RMVtransport"
  ];

  meta = with lib; {
    homepage = "https://github.com/cgtobi/PyRMVtransport";
    description = "Get transport information from opendata.rmv.de";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
