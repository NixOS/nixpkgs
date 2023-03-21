{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pynacl
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pynuki";
  version = "1.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = pname;
    rev = version;
    hash = "sha256-iGP8Bs5Jg8Xu1gAhpbB5lfrZjsF7X+lIt4dJP3fdhD8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pynacl
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pynuki"
  ];

  meta = with lib; {
    description = "Python bindings for nuki.io bridges";
    homepage = "https://github.com/pschmitt/pynuki";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
