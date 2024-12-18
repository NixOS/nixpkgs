{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  scipy,
  sympy,
  setuptools,
  pynose,
  cython,
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

  nativeCheckInputs = [
    pynose
    cython
  ];

  checkPhase = ''
    runHook preCheck

    nosetests pydy

    runHook postCheck
  '';

  pythonImportsCheck = [ "pydy" ];

  meta = with lib; {
    description = "Python tool kit for multi-body dynamics";
    homepage = "http://pydy.org";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
