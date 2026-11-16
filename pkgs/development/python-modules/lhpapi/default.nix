{
  lib,
  beautifulsoup4,
  lxml,
  hatchling,
  requests,
  tzdata,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "lhpapi";
  version = "1.0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stephan192";
    repo = "lhpapi";
    tag = "v${version}";
    hash = "sha256-a+ehnnBtIQcd9etIQvrLOz2o0wUrNUZkGBoI5nUHKxk=";
  };

  dependencies = [
    beautifulsoup4
    lxml
    requests
    tzdata
  ];

  build-system = [ hatchling ];

  pythonImportsCheck = [ "lhpapi" ];

  meta = {
    description = "API to retrieve data from the Länderübergreifendes Hochwasser Portal (LHP)";
    homepage = "https://github.com/stephan192/lhpapi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _9R ];
  };
}
