{ lib
, buildPythonPackage
, fetchPypi
, flake8
, orderedmultidict
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "furl";
  version = "2.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a6188fe2666c484a12159c18be97a1977a71d632ef5bb867ef15f54af39cc4e";
  };

  propagatedBuildInputs = [
    orderedmultidict
    six
  ];

  checkInputs = [
    flake8
    pytestCheckHook
  ];

  pythonImportsCheck = [ "furl" ];

  meta = with lib; {
    description = "Python library that makes parsing and manipulating URLs easy";
    homepage = "https://github.com/gruns/furl";
    license = licenses.unlicense;
    maintainers = with maintainers; [ vanzef ];
  };
}
