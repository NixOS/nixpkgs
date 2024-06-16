{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  exceptiongroup,
  h11,
  h2,
  priority,
  wsproto,
  poetry-core,
  pytest-asyncio,
  pytest-trio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hypercorn";
  version = "0.16.0";
  format = "pyproject";

  disabled = pythonOlder "3.11"; # missing taskgroup dependency

  src = fetchFromGitHub {
    owner = "pgjones";
    repo = "Hypercorn";
    rev = version;
    hash = "sha256-pIUZCQmC3c6FiV0iMMwJGs9TMi6B/YM+vaSx//sAmKE=";
  };

  postPatch = ''
    sed -i "/^addopts/d" pyproject.toml
  '';

  build-system = [ poetry-core ];

  dependencies = [
    exceptiongroup
    h11
    h2
    priority
    wsproto
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-trio
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/pgjones/hypercorn/issues/217
    "test_startup_failure"
  ];

  pythonImportsCheck = [ "hypercorn" ];

  meta = with lib; {
    homepage = "https://github.com/pgjones/hypercorn";
    description = "The ASGI web server inspired by Gunicorn";
    mainProgram = "hypercorn";
    license = licenses.mit;
    maintainers = with maintainers; [ dgliwka ];
  };
}
