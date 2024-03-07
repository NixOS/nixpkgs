{ lib
, buildPythonPackage
, fetchPypi
, sanic
, sanic-testing
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sanic-auth";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "Sanic-Auth";
    inherit version;
    sha256 = "0dc24ynqjraqwgvyk0g9bj87zgpq4xnssl24hnsn7l5vlkmk8198";
  };

  propagatedBuildInputs = [
    sanic
  ];

  nativeCheckInputs = [
    pytestCheckHook
    sanic-testing
  ];

  disabledTests = [
    # incompatible with sanic>=22.3.0
    "test_login_required"
  ];

  postPatch = ''
    # Support for httpx>=0.20.0
    substituteInPlace tests/test_auth.py \
      --replace "allow_redirects=False" "follow_redirects=False"
  '';

  pythonImportsCheck = [
    "sanic_auth"
  ];

  meta = with lib; {
    description = "Simple Authentication for Sanic";
    homepage = "https://github.com/pyx/sanic-auth/";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
