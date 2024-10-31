{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # propagates
  cryptography,
  six,

  # optional
  webob,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-u2flib-server";
  version = "5.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "python-u2flib-server";
    rev = version;
    hash = "sha256-ginP9u+aHcdaWpwcFYJWu0Ghf7+nDZq9i3TVAacIPhg=";
  };

  patches = [ ./cryptography-37-compat.patch ];

  propagatedBuildInputs = [
    cryptography
    six
  ];

  optional-dependencies = {
    u2f_server = [ webob ];
  };

  pythonImportsCheck = [
    "u2flib_server"
    "u2flib_server.u2f"
  ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.u2f_server;

  meta = with lib; {
    description = "Python based U2F server library";
    homepage = "https://github.com/Yubico/python-u2flib-server";
    changelog = "https://github.com/Yubico/python-u2flib-server/blob/${src.rev}/NEWS";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
  };
}
