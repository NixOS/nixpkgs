{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  future,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "autograd";
  version = "1.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hzHgigxOOJ2GlaQAcq2kUSZBwRO2ys6PTPvo636a7es=";
  };

  propagatedBuildInputs = [
    numpy
    future
  ];

  # Currently, the PyPI tarball doesn't contain the tests. When that has been
  # fixed, enable testing. See: https://github.com/HIPS/autograd/issues/404
  doCheck = false;

  pythonImportsCheck = [ "autograd" ];

  meta = with lib; {
    homepage = "https://github.com/HIPS/autograd";
    description = "Compute derivatives of NumPy code efficiently";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
