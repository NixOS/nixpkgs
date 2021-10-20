{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "immutabledict";
  version = "2.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "corenting";
    repo = "immutabledict";
    rev = "v${version}";
    sha256 = "sha256-z04xxoCw0eBtkt++y/1yUsAPaLlAGUtWBdRBM74ul1c=";
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

