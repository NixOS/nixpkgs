{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, poetry-core
}:

buildPythonPackage rec {
  pname = "pathable";
  version = "0.4.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-4QRFjbeaggoEPVGAmSY+qVMNW0DKqarNfRXaH6B58ew=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
  '';

  pythonImportsCheck = [
    "pathable"
  ];

  meta = with lib; {
    description = "Library for object-oriented paths";
    homepage = "https://github.com/p1c2u/pathable";
    changelog = "https://github.com/p1c2u/pathable/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
