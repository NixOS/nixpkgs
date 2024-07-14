{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  numpy,
  scipy,
  matplotlib,
  pytest,
}:

buildPythonPackage rec {
  pname = "nimfa";
  version = "1.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Oc/yuGhW0Dyoo9nDhZgDTs8adowyX9OnKLuerbjGuRk=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
  ];
  nativeCheckInputs = [
    matplotlib
    pytest
  ];
  doCheck = !isPy3k; # https://github.com/marinkaz/nimfa/issues/42

  meta = with lib; {
    description = "Nonnegative matrix factorization library";
    homepage = "http://nimfa.biolab.si";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
