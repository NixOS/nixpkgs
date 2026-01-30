{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pythonAtLeast,
  pythonOlder,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  numpy,
  packaging,
  importlib-resources,
  typing-extensions,

  # optional-dependencies
  pydicom,
  pillow,
  h5py,
  scipy,

  addBinToPathHook,
  gitMinimal,
  pytest-doctestplus,
  pytest-httpserver,
  pytest-xdist,
  pytest7CheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nibabel";
  version = "5.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nipy";
    repo = "nibabel";
    tag = finalAttrs.version;
    hash = "sha256-Kdz7kCY5QnA9OiV/FPW1RerjP1GGLn+YaTwFpA0dJAM=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/nipy/nibabel/commit/3f40a3bc0c4bd996734576a15785ad0f769a963a.patch?full_index=1";
      hash = "sha256-URsxgP6Sd5IIOX20GtAYtWBWOhw+Hiuhgu1oa8o8NXk=";
    })
  ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    numpy
    packaging
  ]
  ++ lib.optionals (pythonOlder "3.12") [ importlib-resources ]
  ++ lib.optionals (pythonOlder "3.13") [ typing-extensions ];

  optional-dependencies = lib.fix (self: {
    all = self.dicom ++ self.dicomfs ++ self.minc2 ++ self.spm ++ self.zstd;
    dicom = [ pydicom ];
    dicomfs = [ pillow ] ++ self.dicom;
    minc2 = [ h5py ];
    spm = [ scipy ];
    zstd = [
      # TODO: pyzstd
    ];
  });

  nativeCheckInputs = [
    addBinToPathHook
    gitMinimal
    pytest-doctestplus
    pytest-httpserver
    pytest-xdist
    pytest7CheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.all;

  disabledTests = lib.optionals (pythonAtLeast "3.14") [
    # https://github.com/nipy/nibabel/issues/1390
    "test_deprecator_maker"
  ];

  meta = {
    homepage = "https://nipy.org/nibabel";
    changelog = "https://github.com/nipy/nibabel/blob/${finalAttrs.version}/Changelog";
    description = "Access a multitude of neuroimaging data formats";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ashgillman ];
  };
})
