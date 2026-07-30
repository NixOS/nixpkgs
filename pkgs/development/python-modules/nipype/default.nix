{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,
  hatch-vcs,

  # python dependencies
  acres,
  click,
  python-dateutil,
  etelemetry,
  filelock,
  looseversion,
  lxml,
  networkx,
  nibabel,
  numpy,
  packaging,
  prov,
  puremagic,
  pybids,
  pydot,
  pytestCheckHook,
  pytest-xdist,
  pytest-cov-stub,
  rdflib,
  scipy,
  simplejson,
  traits,

  # optional-dependencies
  datalad,
  duecredit,
  pandas,
  paramiko,
  psutil,
  sphinx,
  xvfbwrapper,

  # other dependencies
  which,
  bash,
  glibcLocales,
}:

buildPythonPackage rec {
  pname = "nipype";
  version = "1.11.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZwfsTDz44Zg673+O6nlifue3q0qklkmZFVDhKcFlt6c=";
  };

  postPatch = ''
    substituteInPlace nipype/interfaces/base/tests/test_core.py \
      --replace-fail "/usr/bin/env bash" "${bash}/bin/bash"
    substituteInPlace nipype/pipeline/engine/tests/test_nodes.py \
      --replace-fail "/bin/bash" "${bash}/bin/bash"
  '';

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    acres
    click
    etelemetry
    filelock
    looseversion
    lxml
    networkx
    nibabel
    numpy
    packaging
    prov
    puremagic
    pydot
    python-dateutil
    rdflib
    scipy
    simplejson
    traits
  ];

  passthru.optional-dependencies = {
    data = [ datalad ];
    duecredit = [ duecredit ];
    profiler = [ psutil ];
    pybids = [ pybids ];
    ssh = [ paramiko ];
    xvfbwrapper = [ xvfbwrapper ];
  };

  nativeCheckInputs = [
    glibcLocales
    pandas
    pytestCheckHook
    pytest-cov-stub
    pytest-xdist
    sphinx
    which
  ];

  # checks on darwin inspect memory which doesn't work in build environment
  doCheck = !stdenv.hostPlatform.isDarwin;

  pythonImportsCheck = [
    "nipype"
    "nipype.algorithms"
    "nipype.interfaces"
  ];

  meta = {
    homepage = "https://nipy.org/nipype";
    description = "Neuroimaging in Python: Pipelines and Interfaces";
    changelog = "https://github.com/nipy/nipype/releases/tag/${version}";
    mainProgram = "nipypecli";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ashgillman ];
  };
}
