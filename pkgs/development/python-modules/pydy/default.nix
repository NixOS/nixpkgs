{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  scipy,
  sympy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pydy";
  version = "0.7.1";

  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aaRinJMGR8v/OVkeSp1hA4+QLOrmDWq50wvA6b/suvk=";
  };

  dependencies = [
    numpy
    scipy
    sympy
  ];

  # nose test does not support 3.10 or later
  doCheck = false;

  pythonImportsCheck = [ "pydy" ];

  meta = with lib; {
    description = "Python tool kit for multi-body dynamics";
    homepage = "http://pydy.org";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
