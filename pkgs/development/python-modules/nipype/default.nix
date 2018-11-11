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
}:

assert !isPy3k -> configparser != null;

buildPythonPackage rec {
  pname = "nipype";
  version = "1.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d49bbe531cdbf0a049f1581e4d3c63231ff5978445cb380aa6e7f8f1d256a29c";
  };

  # see https://github.com/nipy/nipype/issues/2240
  patches = [ ./prov-version.patch ];

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

  checkInputs = [ pytest mock pytestcov pytest_xdist pytest-forked codecov which glibcLocales ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test -v --doctest-modules nipype
  '';

  meta = with stdenv.lib; {
    homepage = http://nipy.org/nipype/;
    description = "Neuroimaging in Python: Pipelines and Interfaces";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
