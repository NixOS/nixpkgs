{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, ifaddr
, lxml
, poetry-core
, pytest-vcr
, pytestCheckHook
, pythonOlder
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "pywemo";
  version = "0.6.4";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1hm1vs6m65vqar0lcjnynz0d9y9ri5s75fzhvp0yfjkcnp06gnfa";
  };

  patches = [
    (fetchpatch {
      # https://github.com/pywemo/pywemo/issues/264
      url = "https://github.com/pywemo/pywemo/commit/4fd7af8ccc7cb2412f61d5e04b79f83c9ca4753c.patch";
      sha256 = "1x0rm5dxr0z5llmv446bx3i1wvgcfhx22zn78qblcr0m4yv3mif4";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    ifaddr
    requests
    urllib3
    lxml
  ];

  checkInputs = [
    pytest-vcr
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pywemo" ];

  meta = with lib; {
    description = "Python module to discover and control WeMo devices";
    homepage = "https://github.com/pywemo/pywemo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
