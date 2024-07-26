{ lib
, buildPythonPackage
, fetchPypi
, cython
, jinja2
, numpy
, pyparsing
, setuptools
, sympy
, pytest
, pytest-xdist
, python
}:

buildPythonPackage rec {
  pname = "brian2";
  version = "2.5.4";
  format = "setuptools";

  src = fetchPypi {
    pname = "Brian2";
    inherit version;
    hash = "sha256-XMXSOwcH8fLgzXCcT+grjYxhBdtF4H/Vr+S7J4GYZSw=";
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
    description = "A clock-driven simulator for spiking neural networks";
    homepage = "https://briansimulator.org/";
    license = licenses.cecill21;
    maintainers = with maintainers; [ jiegec ];
  };
}
