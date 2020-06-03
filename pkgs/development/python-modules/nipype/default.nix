{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
# python dependencies
, click
, dateutil
, etelemetry
, filelock
, funcsigs
, future
, mock
, networkx
, nibabel
, numpy
, packaging
, pathlib2
, prov
, psutil
, pybids
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
, sphinx
# other dependencies
, which
, bash
, glibcLocales
, callPackage
}:

let

 # This is a temporary convenience package for changes waiting to be merged into the primary rdflib repo.
 neurdflib = callPackage ./neurdflib.nix { };

in

buildPythonPackage rec {
  pname = "nipype";
  version = "1.5.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a9xapw2cvpbs9dvrg5bzx7hw8fr5j50r8mc27cqb3m6vappx0wc";
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
    dateutil
    etelemetry
    filelock
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
  ];

  checkInputs = [
    pybids
    codecov
    glibcLocales
    mock
    pytest
    pytest-forked
    pytest_xdist
    pytestcov
    which
  ];

  # checks on darwin inspect memory which doesn't work in build environment
  doCheck = !stdenv.isDarwin;
  # ignore tests which incorrect fail to detect xvfb
  checkPhase = ''
    LC_ALL="en_US.UTF-8" pytest nipype/tests -k 'not display'
  '';
  pythonImportsCheck = [ "nipype" ];

  meta = with stdenv.lib; {
    homepage = "https://nipy.org/nipype/";
    description = "Neuroimaging in Python: Pipelines and Interfaces";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
