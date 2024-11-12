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
  version = "2.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mp1xo6ooYm21s6FYcegQdsHmVgH81usV9IfIM0GM7lc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cython
    jinja2
    numpy
    pyparsing
    setuptools
    sympy
  ];

  nativeCheckInputs = [
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
