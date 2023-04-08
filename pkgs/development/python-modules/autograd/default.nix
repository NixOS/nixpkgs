{ lib, buildPythonPackage, fetchPypi, numpy, future }:

buildPythonPackage rec {
  pname = "autograd";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2AvSJRVNHbE8tOrM96GMNYvnIJJkG2hxf5b88dFqzQs=";
  };

  propagatedBuildInputs = [ numpy future ];

  # Currently, the PyPI tarball doesn't contain the tests. When that has been
  # fixed, enable testing. See: https://github.com/HIPS/autograd/issues/404
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/HIPS/autograd";
    description = "Compute derivatives of NumPy code efficiently";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
