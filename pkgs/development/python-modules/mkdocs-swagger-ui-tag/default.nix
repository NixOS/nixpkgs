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
  version = "0.5.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qurnqgpsppO4LPg8fN6HobUoNHQTDI6OmEDjVtObA78=";
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
