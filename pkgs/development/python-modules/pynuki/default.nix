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
  version = "1.6.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-I0eAhgThSBEmJF6mYw+0Bh1kCUqEMFnCx+4n7l3Hf14=";
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
    changelog = "https://github.com/pschmitt/pynuki/releases/tag/${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
