{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, poetry-core
}:

buildPythonPackage rec {
  pname = "pathable";
  version = "0.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = version;
    hash = "sha256-3qekweG+o7f6nm1cnCEHrWYn/fQ42GZrZkPwGbZcU38=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
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
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
