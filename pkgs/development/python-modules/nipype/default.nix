{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
# python dependencies
, click
, configparser ? null
, dateutil
, funcsigs
, future
, futures
, mock
, networkx
, nibabel
, numpy
, packaging
, prov
, psutil
, pydot
, pytest
, pytest_xdist
, pytest-forked
, scipy
, simplejson
, traits
, xvfbwrapper
, pytestcov
, codecov
# other dependencies
, which
, bash
, glibcLocales
, callPackage
}:

assert !isPy3k -> configparser != null;

let

 # This is a temporary convenience package for changes waiting to be merged into the primary rdflib repo.
 neurdflib = callPackage ./neurdflib.nix { };

in

buildPythonPackage rec {
  pname = "nipype";
  version = "1.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f80096ec6cfd7cffc05764bba1749e424877140ef1373193f076bdd843f19016";
  };

  postPatch = ''
    substituteInPlace nipype/interfaces/base/tests/test_core.py \
      --replace "/usr/bin/env bash" "${bash}/bin/bash"
  '';

  propagatedBuildInputs = [
    click
    dateutil
    funcsigs
    future
    networkx
    neurdflib
    nibabel
    numpy
    packaging
    prov
    psutil
    pydot
    scipy
    simplejson
    traits
    xvfbwrapper
  ] ++ stdenv.lib.optional (!isPy3k) [
    configparser
    futures
  ];

  checkInputs = [
    codecov
    glibcLocales
    mock
    pytest
    pytest-forked
    pytest_xdist
    pytestcov
    which
  ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" pytest -v --doctest-modules nipype
  '';

  # See: https://github.com/nipy/nipype/issues/2839
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://nipy.org/nipype/;
    description = "Neuroimaging in Python: Pipelines and Interfaces";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
