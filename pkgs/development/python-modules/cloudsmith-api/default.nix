{
  lib,
  buildPythonPackage,
  certifi,
  fetchPypi,
  python-dateutil,
  pythonOlder,
  six,
  urllib3,
}:

buildPythonPackage rec {
  pname = "cloudsmith-api";
<<<<<<< HEAD
  version = "2.0.22";
=======
  version = "2.0.21";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "wheel";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "cloudsmith_api";
    inherit format version;
<<<<<<< HEAD
    hash = "sha256-FZcDjrK5+oHC3dVBSXf+txW6hofP6OkmkjO4NJF05YQ=";
=======
    hash = "sha256-tReoNsSg90wReH/SVa2LAdy5q7DCnWJwnamisPkIuXs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [
    certifi
    python-dateutil
    six
    urllib3
  ];

  # Wheels have no tests
  doCheck = false;

  pythonImportsCheck = [ "cloudsmith_api" ];

  meta = {
    description = "Cloudsmith API Client";
    homepage = "https://github.com/cloudsmith-io/cloudsmith-api";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ usertam ];
  };
}
