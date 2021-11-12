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
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b7a9aed7e61a3828f5a11774803edc39358e2ac463b3b5e52af267f3420dc66";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "'pytest-runner'," ""
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
