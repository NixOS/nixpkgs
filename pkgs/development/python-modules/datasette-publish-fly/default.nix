{
  lib,
  buildPythonPackage,
  cogapp,
  datasette,
  fetchFromGitHub,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "datasette-publish-fly";
  version = "1.3.1";
  format = "setuptools";

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

  meta = {
    description = "Datasette plugin for publishing data using Fly";
    homepage = "https://datasette.io/plugins/datasette-publish-fly";
    changelog = "https://github.com/simonw/datasette-publish-fly/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
