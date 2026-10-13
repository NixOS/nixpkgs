{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

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
  rdflib,
  scipy,
  simplejson,
  traits,

  # optional-dependencies
  datalad,
  duecredit,
  paramiko,
  psutil,
  xvfbwrapper,

  # tests
  bash,
  glibcLocales,
  pandas,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-doctestplus,
  pytest-env,
  pytest-timeout,
  pytest-xdist,
  sphinx,
  which,
}:

buildPythonPackage (finalAttrs: {
  pname = "nipype";
  version = "1.11.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nipy";
    repo = "nipype";
    tag = finalAttrs.version;
    hash = "sha256-Xa7hoD+UvxozXsW4ztjQfKPmvHJL42EMuu95rWWlbe8=";
  };

  postPatch = ''
    substituteInPlace nipype/interfaces/base/tests/test_core.py \
      --replace-fail "/usr/bin/env bash" "${lib.getExe bash}"
    substituteInPlace nipype/pipeline/engine/tests/test_nodes.py \
      --replace-fail "/bin/bash" "${lib.getExe bash}"
  ''
  # `nilearn.input_data` was renamed to `nilearn.maskers` in nilearn 0.9 and dropped in 0.13
  + ''
    substituteInPlace nipype/interfaces/nilearn.py \
      --replace-fail \
        "import nilearn.input_data as nl" \
        "import nilearn.maskers as nl"
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

  optional-dependencies = {
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
    pytest-doctestplus
    pytest-env
    pytest-timeout
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
    description = "Neuroimaging in Python: Pipelines and Interfaces";
    homepage = "https://nipy.org/nipype";
    downloadPage = "https://github.com/nipy/nipype";
    changelog = "https://github.com/nipy/nipype/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "nipypecli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ashgillman ];
  };
})
