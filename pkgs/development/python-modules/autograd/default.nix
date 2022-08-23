{ lib, buildPythonPackage, fetchPypi, numpy, future }:

buildPythonPackage rec {
  pname = "autograd";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OD3g9TfvLji4X/lpJZOwz66JWMmzvUUbUsJV/ZFx/84=";
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
