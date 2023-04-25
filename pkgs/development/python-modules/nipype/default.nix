{ lib, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonRelaxDepsHook
# python dependencies
, click
, python-dateutil
, etelemetry
, filelock
, funcsigs
, future
, looseversion
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
, codecov
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

buildPythonPackage rec {
  pname = "nipype";
  version = "1.8.5";
  disabled = pythonOlder "3.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-44QnQ/tmBGTdKd5z3Pye9m0nO+ELzGQFn/Ic1e8ellU=";
  };

  postPatch = ''
    substituteInPlace nipype/interfaces/base/tests/test_core.py \
      --replace "/usr/bin/env bash" "${bash}/bin/bash"
  '';

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "traits" ];

  propagatedBuildInputs = [
    click
    python-dateutil
    etelemetry
    filelock
    funcsigs
    future
    looseversion
    networkx
    nibabel
    numpy
    packaging
    prov
    psutil
    pydot
    rdflib
    scipy
    simplejson
    traits
    xvfbwrapper
  ];

  nativeCheckInputs = [
    pybids
    codecov
    glibcLocales
    mock
    pytest
    pytest-forked
    pytest-xdist
    which
  ];

  # checks on darwin inspect memory which doesn't work in build environment
  doCheck = !stdenv.isDarwin;
  # ignore tests which incorrect fail to detect xvfb
  checkPhase = ''
    LC_ALL="en_US.UTF-8" pytest nipype/tests -k 'not display and not test_no_et_multiproc'
  '';
  pythonImportsCheck = [ "nipype" ];

  meta = with lib; {
    homepage = "https://nipy.org/nipype/";
    description = "Neuroimaging in Python: Pipelines and Interfaces";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
