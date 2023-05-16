{ lib
, buildPythonPackage
, fetchPypi
, djangorestframework
, six
}:

buildPythonPackage rec {
  pname = "djangorestframework-camel-case";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-za51hGZIq7ZYXHRwY5odL7Bk3EX46LYqqlC+fxp6YfQ=";
  };

  propagatedBuildInputs = [
    djangorestframework
  ];

  nativeCheckInputs = [
    six
  ];

  # tests are only on GitHub but there are no tags
  # https://github.com/vbabiy/djangorestframework-camel-case/issues/116
  doCheck = false;

  pythonImportsCheck = [ "djangorestframework_camel_case" ];

  meta = with lib; {
    description = "Camel case JSON support for Django REST framework";
    homepage = "https://github.com/vbabiy/djangorestframework-camel-case";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
