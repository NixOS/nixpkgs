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
  version = "1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    hash = "sha256-0frP/RkpZX6LCR8cOlzcBG3pbcOh0KPuELlYUXS3dRE=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
