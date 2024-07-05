{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  jinja2,
  numpy,
  pyparsing,
  setuptools,
  sympy,
  pytest,
  pytest-xdist,
  python,
}:

buildPythonPackage rec {
  pname = "brian2";
  version = "2.6.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "Brian2";
    inherit version;
    hash = "sha256-qYeIMn8l2V2Ckpj5AY7TWihFnfZ//JcP5VacUUfYCf4=";
  };

  propagatedBuildInputs = [
    cython
    jinja2
    numpy
    pyparsing
    setuptools
    sympy
  ];

  checkInputs = [
    pytest
    pytest-xdist
  ];

  checkPhase = ''
    runHook preCheck
    # Cython cache lies in home directory
    export HOME=$(mktemp -d)
    cd $HOME && ${python.interpreter} -c "import brian2;assert brian2.test()"
    runHook postCheck
  '';

  meta = with lib; {
    description = "Clock-driven simulator for spiking neural networks";
    homepage = "https://briansimulator.org/";
    license = licenses.cecill21;
    maintainers = with maintainers; [ jiegec ];
  };
}
