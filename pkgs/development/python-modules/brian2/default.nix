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

  src = fetchPypi {
    pname = "Brian2";
    inherit version;
    hash = "sha256-XMXSOwcH8fLgzXCcT+grjYxhBdtF4H/Vr+S7J4GYZSw=";
  };

  patches = [
    # Fix deprecated numpy types
    # https://sources.debian.org/data/main/b/brian/2.5.1-3/debian/patches/numpy1.24.patch
    ./numpy1.24.patch
  ];

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
