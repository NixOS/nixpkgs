{
  lib,
  buildPythonPackage,
  fetchPypi,
  python-dateutil,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ghp-import";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nFNcTGEZPC34hxIiVn1/1+UBTYNfl9x7dDkGniQT00M=";
  };

  propagatedBuildInputs = [ python-dateutil ];

  # Does not include any unit tests
  doCheck = false;

  pythonImportsCheck = [ "ghp_import" ];

  meta = with lib; {
    description = "Copy your docs directly to the gh-pages branch";
    mainProgram = "ghp-import";
    homepage = "https://github.com/c-w/ghp-import";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch ];
  };
}
