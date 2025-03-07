{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  requests,
  selenium,
  webdriver-manager,
}:
buildPythonPackage rec {
  pname = "html2print";
  pyproject = true;
  version = "0.0.15";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AYIZeYnamnv9MyFbRmWbKFQsQPkhjYsEHaCvXvXOZ34=";
  };

  build-system = [ hatchling ];

  dependencies = [
    selenium
    webdriver-manager
    requests
  ];

  meta = with lib; {
    description = "Python client for HTML2PDF JavaScript library";
    homepage = "https://github.com/tree-sitter/tree-sitter-cpp";
    license = licenses.mit;
    maintainers = with maintainers; [ dadada ];
  };
}
