{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "jsonpath-python";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sean2077";
    repo = "jsonpath-python";
    rev = "aead1e4db9890f12fc029ca57b9732aa16c62915";
    hash = "sha256-q1wjtW1USn88ISYDTnT6DA57WmZeUP25U2zrR8B/Rfk=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "jsonpath" ];

  meta = with lib; {
    description = "A more powerful JSONPath implementations in modern python";
    homepage = "https://github.com/sean2077/jsonpath-python";
    changelog = "https://github.com/sean2077/jsonpath-python/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
