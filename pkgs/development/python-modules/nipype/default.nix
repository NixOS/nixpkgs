{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  # python dependencies
  click,
  python-dateutil,
  etelemetry,
  filelock,
  looseversion,
  mock,
  networkx,
  nibabel,
  numpy,
  packaging,
  prov,
  psutil,
  puremagic,
  pybids,
  pydot,
  pytest,
  pytest-xdist,
  pytest-forked,
  rdflib,
  scipy,
  simplejson,
  traits,
  xvfbwrapper,
  # other dependencies
  which,
  bash,
  glibcLocales,
  # causes Python packaging conflict with any package requiring rdflib,
  # so use the unpatched rdflib by default (disables Nipype provenance tracking);
  # see https://github.com/nipy/nipype/issues/2888:
  useNeurdflib ? false,
}:

buildPythonPackage rec {
  pname = "nipype";
  version = "1.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GeXWzvpwmXGY94vGZe9NPTy1MyW1uYpy5Rrvra9rPg4=";
  };

  postPatch = ''
    substituteInPlace nipype/interfaces/base/tests/test_core.py \
      --replace-fail "/usr/bin/env bash" "${bash}/bin/bash"
  '';

  pythonRelaxDeps = [ "traits" ];

  dependencies = [
    click
    python-dateutil
    etelemetry
    filelock
    looseversion
    networkx
    nibabel
    numpy
    packaging
    prov
    psutil
    puremagic
    pydot
    rdflib
    scipy
    simplejson
    traits
    xvfbwrapper
  ];

  nativeCheckInputs = [
    pybids
    glibcLocales
    mock
    pytest
    pytest-forked
    pytest-xdist
    which
  ];

  # checks on darwin inspect memory which doesn't work in build environment
  doCheck = !stdenv.hostPlatform.isDarwin;
  # ignore tests which incorrect fail to detect xvfb
  checkPhase = ''
    pytest nipype/tests -k 'not display and not test_no_et_multiproc'
  '';
  pythonImportsCheck = [ "nipype" ];

  meta = {
    homepage = "https://nipy.org/nipype";
    description = "Neuroimaging in Python: Pipelines and Interfaces";
    changelog = "https://github.com/nipy/nipype/releases/tag/${version}";
    mainProgram = "nipypecli";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ashgillman ];
  };
}
