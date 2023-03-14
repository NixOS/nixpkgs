{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, poetry-core
, httpx
, pydicom
}:

buildPythonPackage rec {
  pname = "pyorthanc";
  version = "1.11.4";
  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "gacou54";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-HbNeI6KpdIoLwRx09qQGJ/iJGKnRj0Z4/mkgoXhofGA=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ httpx pydicom ];

  doCheck = false;  # requires orthanc server (not in Nixpkgs)

  pythonImportsCheck = [
    "pyorthanc"
  ];

  meta = with lib; {
    description = "Python library that wraps the Orthanc REST API";
    homepage = "https://github.com/gacou54/pyorthanc";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
