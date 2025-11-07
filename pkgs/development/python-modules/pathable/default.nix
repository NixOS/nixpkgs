{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pathable";
  version = "0.4.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "pathable";
    tag = version;
    hash = "sha256-nN5jpI0Zi5ofdSuN9QbTHDXPmQRq9KAn8SoHuNDpZaw=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "pathable" ];

  meta = with lib; {
    description = "Library for object-oriented paths";
    homepage = "https://github.com/p1c2u/pathable";
    changelog = "https://github.com/p1c2u/pathable/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
