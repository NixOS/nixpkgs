{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  # build:
  ninja,
  setuptools,

  # dependencies:
  torch,
  bcrypt,
  cachetools,
  dicomweb-client,
  einops,
  expiring-dict,
  expiringdict,
  fastapi,
  filelock,
  girder-client,
  google-auth,
  httpx,
  monai,
  passlib,
  pydantic,
  pydantic-settings,
  pydicom,
  pydicom-seg,
  pyjwt,
  pynetdicom,
  pynrrd,
  python-dotenv,
  python-multipart,
  pyyaml,
  requests,
  requests-toolbelt,
  schedule,
  scikit-learn,
  scipy,
  shapely,
  timeloop,
  urllib3,
  uvicorn,
  watchdog,

  # test
  pytestCheckHook,
  parameterized,
}:

buildPythonPackage rec {
  pname = "monai-label";
  version = "0.8.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Project-MONAI";
    repo = "MONAILabel";
    rev = "refs/tags/${version}";
    hash = "sha256-4XhL8zdYz33UIyIk9aih8GsFj2ktSt07sCKk0mgpXFw=";
  };

  postPatch = ''
    patchShebangs monailabel/scripts/monailabel
  '';

  build-system = [
    ninja
    setuptools
  ];

  dependencies =
    [
      bcrypt
      cachetools
      dicomweb-client
      einops
      expiring-dict
      expiringdict
      fastapi
      filelock
      girder-client
      google-auth
      httpx
      monai
      passlib
      pydantic
      pydantic-settings
      pydicom
      pydicom-seg
      pyjwt
      pynetdicom
      pynrrd
      python-dotenv
      python-multipart
      pyyaml
      requests
      requests-toolbelt
      schedule
      scikit-learn
      scipy
      shapely
      timeloop
      torch
      urllib3
      uvicorn
      watchdog
    ]
    ++ (
      let
        d = monai.optional-dependencies;
      in
      lib.flatten [
        d.fire
        d.gdown
        d.ignite
        d.itk
        d.lmdb
        d.mlflow
        d.nibabel
        d.numpymaxflow
        d.openslide
        d.pillow
        d.psutil
        d.scikit-image
        d.tensorboard
        d.torchvision
        d.tqdm
      ]
    );

  pythonRelaxDeps = true;

  pythonImportsCheck = [
    "monailabel"
    "monailabel.app"
    "monailabel.config"
    "monailabel.main"
    "monailabel.client"
    "monailabel.datastore"
    "monailabel.deepedit"
    "monailabel.interfaces"
    "monailabel.scribbles"
    "monailabel.tasks"
    "monailabel.transform"
    "monailabel.utils"
  ];

  doCheck = true;
  nativeCheckInputs = [
    pytestCheckHook
    parameterized
  ];

  preCheck = ''rm -rf monailabel/'';

  disabledTestPaths = [
    "plugins/cellprofiler/test_runvista2d.py" # needs cellprofiler, not in nixpkgs
    "tests/integration/monaibundle/detection" # plugin issue

    # try to download data/access nonexistent data:
    "tests/integration/pathology/test_info.py"
    "tests/integration/radiology"
    "tests/unit/datastore"
    "tests/unit/deepedit/test_planner.py"
    "tests/unit/endpoints"
    "tests/unit/test_main.py" # also some sort of plugin issue
    "tests/unit/utils/test_sessions.py"
  ];

  meta = {
    description = "Tool/framework for labeling and deep learning in medical imaging";
    homepage = "https://docs.monai.io/projects/label";
    changelog = "https://github.com/Project-MONAI/MONAILabel/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
