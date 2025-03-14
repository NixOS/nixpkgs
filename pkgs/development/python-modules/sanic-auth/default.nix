{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sanic,
  sanic-testing,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sanic-auth";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "Sanic-Auth";
    inherit version;
    hash = "sha256-KAU066S70GO1hURQrW0n+L5/kFzpgen341hlia0ngjU=";
  };

  build-system = [ setuptools ];

  dependencies = [ sanic ];

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
      --replace-fail "allow_redirects=False" "follow_redirects=False"
  '';

  pythonImportsCheck = [ "sanic_auth" ];

  meta = with lib; {
    description = "Simple Authentication for Sanic";
    homepage = "https://github.com/pyx/sanic-auth/";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
