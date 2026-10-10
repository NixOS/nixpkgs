{
  lib,
  fetchPypi,
  buildPythonPackage,
  requests,
  hidapi,
}:

buildPythonPackage rec {
  pname = "python-u2flib-host";
  version = "3.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q2eLncKUZqd578qi8BUNzjUFmn0XaA/CYFf6WZpT/Ao=";
  };

  propagatedBuildInputs = [
    requests
    hidapi
  ];

  # Tests fail: "ValueError: underlying buffer has been detached"
  doCheck = false;

  meta = {
    description = "Python based U2F host library";
    homepage = "https://github.com/Yubico/python-u2flib-host";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
