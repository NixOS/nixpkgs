{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, furl
, jsonschema
, nose
, pytestCheckHook
, pythonOlder
, requests
, xmltodict
}:

buildPythonPackage rec {
  pname = "pook";
  version = "1.0.1";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "h2non";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z48vswj07kr2sdvq5qzrwqyijpmj2rlnh2z2b32id1mckr6nnz8";
  };

  patches = [
    (fetchpatch {
      # Will be fixed with the new release, https://github.com/h2non/pook/issues/69
      name = "use-match-keyword-in-pytest.patch";
      url = "https://github.com/h2non/pook/commit/2071da27701c82ce02b015e01e2aa6fd203e7bb5.patch";
      sha256 = "0i3qcpbdqqsnbygi46dyqamgkh9v8rhpbm4lkl75riw48j4n080k";
    })
  ];

  propagatedBuildInputs = [
    aiohttp
    furl
    jsonschema
    requests
    xmltodict
  ];

  checkInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pook" ];

  meta = with lib; {
    description = "HTTP traffic mocking and testing made simple in Python";
    homepage = "https://github.com/h2non/pook";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
