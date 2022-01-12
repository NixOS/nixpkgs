{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
}:

buildPythonPackage rec {
  pname = "ghp-import";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lHs3cfEb6FDIUsZLVhxgD93feUurNjBghUwe560F4HE=";
  };

  propagatedBuildInputs = [ python-dateutil ];

  # Does not include any unit tests
  doCheck = false;

  pythonImportsCheck = [ "ghp_import" ];

  meta = with lib; {
    description = "Copy your docs directly to the gh-pages branch";
    homepage = "https://github.com/c-w/ghp-import";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch ];
  };
}
