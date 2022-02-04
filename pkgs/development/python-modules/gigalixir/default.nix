{ buildPythonApplication
, click
, fetchPypi
, git
, httpretty
, lib
, qrcode
, pygments
, pyopenssl
, pytestCheckHook
, requests
, rollbar
, stripe
, sure
}:

buildPythonApplication rec {
  pname = "gigalixir";
  version = "1.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-P70xsI/zwsoSgK1XCPzJSI5NQ58M431kmgo5gHXbaNw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," "" \
      --replace "cryptography==" "cryptography>="
  '';

  propagatedBuildInputs = [
    click
    requests
    stripe
    rollbar
    pygments
    qrcode
    pyopenssl
  ];

  checkInputs = [
    httpretty
    sure
    pytestCheckHook
    git
  ];

  pythonImportsCheck = [ "gigalixir" ];

  meta = with lib; {
    description = "Gigalixir Command-Line Interface";
    homepage = "https://github.com/gigalixir/gigalixir-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
