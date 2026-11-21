{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  backports-zstd,
  indexed-gzip,
  matplotlib,
  pydicom,
  pillow,
  h5py,
  scipy,

  addBinToPathHook,
  gitMinimal,
  pytest-doctestplus,
  pytest-httpserver,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nibabel";
  version = "5.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nipy";
    repo = "nibabel";
    tag = finalAttrs.version;
    hash = "sha256-GxlsgEz7Wohn4y5I4HbZBzg65pUB028G7CxJbMGAYR8=";
  };

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
    all = self.dicomfs ++ self.indexed_gzip ++ self.minc2 ++ self.spm ++ self.zstd;
    dicom = [ pydicom ];
    dicomfs = [ pillow ] ++ self.dicom;
    indexed_gzip = [ indexed-gzip ];
    minc2 = [ h5py ];
    spm = [ scipy ];
    viewers = [ matplotlib ];
    zstd = lib.optionals (pythonOlder "3.14") [ backports-zstd ];
  });

  nativeCheckInputs = [
    addBinToPathHook
    gitMinimal
    pytest-doctestplus
    pytest-httpserver
    pytest-xdist
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.all;

  pythonImportsCheck = [ "nibabel" ];

  meta = {
    homepage = "https://nipy.org/nibabel";
    changelog = "https://github.com/nipy/nibabel/blob/${finalAttrs.version}/Changelog";
    description = "Access a multitude of neuroimaging data formats";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ashgillman ];
  };
})
