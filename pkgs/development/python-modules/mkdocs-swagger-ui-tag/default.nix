{ lib
, buildPythonPackage
, drawio-headless
, fetchPypi
, pythonOlder
, mkdocs
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "mkdocs-swagger-ui-tag";
  version = "0.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H/eqrwlZntEYoKkJZKiRV+KyzkrDKRirMDDSciFNIGo=";
  };

  propagatedBuildInputs = [
    mkdocs
    beautifulsoup4
  ];

  pythonImportsCheck = [
    "mkdocs_swagger_ui_tag"
  ];

  meta = with lib; {
    description = "A MkDocs plugin supports for add Swagger UI in page";
    homepage = "https://github.com/Blueswen/mkdocs-swagger-ui-tag";
    changelog = "https://github.com/blueswen/mkdocs-swagger-ui-tag/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ snpschaaf ];
  };
}
