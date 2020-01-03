{ stdenv, buildPythonPackage, fetchPypi, numpy, future }:

buildPythonPackage rec {
  pname = "autograd";
  version = "1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1i1ylf03b7220n8znk63zg6sgdd3py9wlh1pvqvy03g1fxsi8pd1";
  };

  propagatedBuildInputs = [ numpy future ];

  # Currently, the PyPI tarball doesn't contain the tests. When that has been
  # fixed, enable testing. See: https://github.com/HIPS/autograd/issues/404
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/HIPS/autograd;
    description = "Compute derivatives of NumPy code efficiently";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
