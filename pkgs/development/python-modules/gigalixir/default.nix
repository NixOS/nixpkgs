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
  version = "1.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "894b7e5bef30abc2c003e6df47f7758de5649b6f593e33926fcd398cc88d9ce2";
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
