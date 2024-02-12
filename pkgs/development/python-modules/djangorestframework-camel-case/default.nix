{ lib
, buildPythonPackage
, fetchPypi
, djangorestframework
, six
}:

buildPythonPackage rec {
  pname = "djangorestframework-camel-case";
  version = "1.4.2";
  format = "setuptools";

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
    maintainers = with maintainers; [ ];
  };
}
