{ lib
, buildPythonPackage
, cogapp
, datasette
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "datasette-publish-fly";
  version = "1.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-L94QYcrTWjuoz0aEFTxPi8Xg0xERP1zCs7+vzhoJagc=";
  };

  propagatedBuildInputs = [
    datasette
  ];

  nativeCheckInputs = [
    cogapp
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "datasette_publish_fly"
  ];

  meta = with lib; {
    description = "Datasette plugin for publishing data using Fly";
    homepage = "https://datasette.io/plugins/datasette-publish-fly";
    changelog = "https://github.com/simonw/datasette-publish-fly/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
