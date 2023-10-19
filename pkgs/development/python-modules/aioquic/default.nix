{ lib
, buildPythonPackage
, certifi
, fetchPypi
, openssl
, pylsqpack
, pyopenssl
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioquic";
  version = "0.9.21";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ecfsBjGOeFYnZlyk6HI63zR7ciW30AbjMtJXWh9RbvU=";
  };

  propagatedBuildInputs = [
    certifi
    pylsqpack
    pyopenssl
  ];

  buildInputs = [
    openssl
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioquic"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Implementation of QUIC and HTTP/3";
    homepage = "https://github.com/aiortc/aioquic";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
