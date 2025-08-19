{
  lib,
  buildPythonPackage,
  cogapp,
  datasette,
  fetchFromGitHub,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "datasette-publish-fly";
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "datasette-publish-fly";
    tag = version;
    hash = "sha256-diaxr+fNNgkJvLGkLo+lK0ThTsXYDePFsvTetMbDRMk=";
  };

  propagatedBuildInputs = [ datasette ];

  nativeCheckInputs = [
    cogapp
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "datasette_publish_fly" ];

  meta = with lib; {
    description = "Datasette plugin for publishing data using Fly";
    homepage = "https://datasette.io/plugins/datasette-publish-fly";
    changelog = "https://github.com/simonw/datasette-publish-fly/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
