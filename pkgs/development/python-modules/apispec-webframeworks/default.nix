{ lib
, apispec
, bottle
, buildPythonPackage
, fetchFromGitHub
, flask
, mock
, pytestCheckHook
, pythonOlder
, tornado
}:

buildPythonPackage rec {
  pname = "apispec-webframeworks";
  version = "0.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "apispec-webframeworks";
    rev = version;
    hash = "sha256-ByNmmBLO99njw9JrT+cCW/K4NJBH92smAiIgg47Cvkk=";
  };

  propagatedBuildInputs = [
    apispec
  ] ++ apispec.optional-dependencies.yaml;

  nativeCheckInputs = [
    bottle
    flask
    mock
    pytestCheckHook
    tornado
  ];

  pythonImportsCheck = [
    "apispec_webframeworks"
  ];

  meta = with lib; {
    description = "Web framework plugins for apispec";
    homepage = "https://github.com/marshmallow-code/apispec-webframeworks";
    changelog = "https://github.com/marshmallow-code/apispec-webframeworks/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
