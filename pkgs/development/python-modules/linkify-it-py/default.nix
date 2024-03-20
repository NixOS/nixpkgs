{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, uc-micro-py
, setuptools
}:

buildPythonPackage rec {
  pname = "linkify-it-py";
  version = "2.0.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tsutsu3";
    repo = "linkify-it-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-BLwIityUZDVdSbvTpLf6QUlZUavWzG/45Nfffn18/vU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    uc-micro-py
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "linkify_it"
  ];

  meta = with lib; {
    description = "Links recognition library with full unicode support";
    homepage = "https://github.com/tsutsu3/linkify-it-py";
    changelog = "https://github.com/tsutsu3/linkify-it-py/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
