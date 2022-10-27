{ lib
, callPackage
, buildPythonPackage
, fetchFromGitHub
, mkdocs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mkdocs-redirects";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-+Ti+Z5gL5vVlQDt+KRw9nNHHKhRtEfguQe1K001DK9E=";
  };

  propagatedBuildInputs = [
    mkdocs
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mkdocs_redirects"
  ];

  meta = with lib; {
    description = "Open source plugin for Mkdocs page redirects";
    homepage = "https://github.com/mkdocs/mkdocs-redirects";
    license = licenses.mit;
    maintainers = with maintainers; [ tfc ];
  };
}
