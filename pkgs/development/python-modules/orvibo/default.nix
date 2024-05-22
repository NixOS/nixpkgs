{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "orvibo";
  version = "1.1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "happyleavesaoc";
    repo = "python-orvibo";
    rev = version;
    sha256 = "sha256-Azmho47CEbRo18emmLKhYa/sViQX0oxUTUk4zdrpOaE=";
  };

  # Project as no tests
  doCheck = false;
  pythonImportsCheck = [ "orvibo" ];

  meta = with lib; {
    description = "Python client to work with Orvibo devices";
    homepage = "https://github.com/happyleavesaoc/python-orvibo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
