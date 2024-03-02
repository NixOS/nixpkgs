{ lib
, apispec
, bottle
, buildPythonPackage
, fetchFromGitHub
, flit-core
, flask
, mock
, pytestCheckHook
, pythonOlder
, tornado
}:

buildPythonPackage rec {
  pname = "apispec-webframeworks";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "apispec-webframeworks";
    rev = "refs/tags/${version}";
    hash = "sha256-zrsqIZ5ZogZsK1ZOL2uy8igS4T8a+19IwL5dMhKw7OA=";
  };

  nativeBuildInputs = [
    flit-core
  ];

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
