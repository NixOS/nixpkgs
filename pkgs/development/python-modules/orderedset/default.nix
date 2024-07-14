{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "orderedset";
  version = "2.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-svXM+1qG57Oz3fGLKXecwYskZTq/nW2kvr7PM3gKbik=";
  };

  meta = with lib; {
    description = "Ordered Set implementation in Cython";
    homepage = "https://pypi.python.org/pypi/orderedset";
    license = licenses.bsd3;
    maintainers = [ ];
    # No support for Python 3.9/3.10
    # https://github.com/simonpercivall/orderedset/issues/36
    broken = true;
  };
}
