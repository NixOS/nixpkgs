{ stdenv, buildPythonPackage, fetchPypi, numpy, future }:

buildPythonPackage rec {
  pname = "autograd";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zd4lhz9dpll4i63jjijbzkzbgmg8h88il7lr7kmcylvadnzm2x0";
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
