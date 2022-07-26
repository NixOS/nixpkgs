{ stdenv
, lib
, buildPythonApplication
, click
, fetchPypi
, git
, httpretty
, qrcode
, pygments
, pyopenssl
, pytestCheckHook
, requests
, rollbar
, stripe
, pythonOlder
, sure
}:

buildPythonApplication rec {
  pname = "gigalixir";
  version = "1.2.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P70xsI/zwsoSgK1XCPzJSI5NQ58M431kmgo5gHXbaNw=";
  };

  propagatedBuildInputs = [
    click
    pygments
    pyopenssl
    qrcode
    requests
    rollbar
    stripe
  ];

  checkInputs = [
    git
    httpretty
    pytestCheckHook
    sure
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," "" \
      --replace "cryptography==" "cryptography>="
  '';

  disabledTests = [
    # Test requires network access
    "test_rollback_without_version"
  ];

  pythonImportsCheck = [
    "gigalixir"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Gigalixir Command-Line Interface";
    homepage = "https://github.com/gigalixir/gigalixir-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
