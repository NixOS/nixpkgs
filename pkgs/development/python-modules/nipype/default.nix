{ lib, stdenv
, buildPythonPackage
, fetchPypi
, isPy27
# python dependencies
, click
, python-dateutil
, etelemetry
, filelock
, funcsigs
, future
, mock
, networkx
, nibabel
, numpy
, packaging
, prov
, psutil
, pybids
, pydot
, pytest
, pytest-xdist
, pytest-forked
, rdflib
, scipy
, simplejson
, traits
, xvfbwrapper
, pytest-cov
, codecov
, sphinx
# other dependencies
, which
, bash
, glibcLocales
, callPackage
# causes Python packaging conflict with any package requiring rdflib,
# so use the unpatched rdflib by default (disables Nipype provenance tracking);
# see https://github.com/nipy/nipype/issues/2888:
, useNeurdflib ? false
}:

let

 # This is a temporary convenience package for changes waiting to be merged into the primary rdflib repo.
 neurdflib = callPackage ./neurdflib.nix { };

in

buildPythonPackage rec {
  pname = "nipype";
  version = "1.8.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Z/qa0NotxWFzweFHRm/MbJImivV8AZl68yiQ1jNvcAQ=";
  };

  postPatch = ''
    substituteInPlace nipype/interfaces/base/tests/test_core.py \
      --replace "/usr/bin/env bash" "${bash}/bin/bash"
  '';

  nativeBuildInputs = [
    sphinx
  ];

  propagatedBuildInputs = [
    click
    python-dateutil
    etelemetry
    filelock
    funcsigs
    future
    networkx
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
  ] ++ [ (if useNeurdflib then neurdflib else rdflib) ];

  checkInputs = [
    pybids
    codecov
    glibcLocales
    mock
    pytest
    pytest-forked
    pytest-xdist
    pytest-cov
    which
  ];

  # checks on darwin inspect memory which doesn't work in build environment
  doCheck = !stdenv.isDarwin;
  # ignore tests which incorrect fail to detect xvfb
  checkPhase = ''
    LC_ALL="en_US.UTF-8" pytest nipype/tests -k 'not display'
  '';
  pythonImportsCheck = [ "nipype" ];

  meta = with lib; {
    homepage = "https://nipy.org/nipype/";
    description = "Neuroimaging in Python: Pipelines and Interfaces";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
