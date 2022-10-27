{ buildPythonPackage
, drawio-headless
, fetchPypi
, isPy3k
, lib
, mkdocs
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "mkdocs-swagger-ui-tag";
  version = "0.4.3";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-N/7JhVX3STsUAz7O6yWkvKz72+3RZA5CNb3Z6FTrdRs=";
  };

  propagatedBuildInputs = [ mkdocs beautifulsoup4 ];

  pythonImportsCheck = [ "mkdocs_swagger_ui_tag" ];

  meta = with lib; {
    description = "A MkDocs plugin supports for add Swagger UI in page.";
    homepage = "https://github.com/Blueswen/mkdocs-swagger-ui-tag";
    license = licenses.mit;
    maintainers = with maintainers; [ snpschaaf ];
  };
}
