{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, isPy38
# python dependencies
, click
, configparser ? null
, dateutil
, etelemetry
, filelock
, funcsigs
, future
, futures
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

assert !isPy3k -> configparser != null;

let

 # This is a temporary convenience package for changes waiting to be merged into the primary rdflib repo.
 neurdflib = callPackage ./neurdflib.nix { };

in

buildPythonPackage rec {
  pname = "nipype";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nr0z0k4xx1vswkp03g1lf8141mr4j2fbwd7wmpay4vz46qcp786";
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
  ] ++ stdenv.lib.optionals (!isPy3k) [
    configparser
    futures
    pathlib2 # darwin doesn't receive this transitively, but it is in install_requires
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
