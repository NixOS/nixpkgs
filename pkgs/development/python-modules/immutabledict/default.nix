{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "immutabledict";
  version = "2.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "corenting";
    repo = "immutabledict";
    rev = "v${version}";
    sha256 = "sha256-Jf7ad3ImPfEvCBrUZ1NVXMCBqwLmd0hwpKfe9rVsehc=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [
    "immutabledict"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A fork of frozendict, an immutable wrapper around dictionaries";
    homepage = "https://github.com/corenting/immutabledict";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}

