{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  plover,
}:

buildPythonPackage (finalAttrs: {
  pname = "plover-stitching";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "panathea";
    repo = "plover_stitching";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Md3LIQ73CAJlA91hfVdZZp9RJElINHYfiFFBBOYrIgs=";
  };

  patches = [
    # Make plover-stitching's blackbox test use the current blackbox_test from Plover.
    # https://github.com/panathea/plover_stitching/pull/1
    ./plover_stitching_pr-1_test-blackbox_modernise_and_fix_build.patch
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    plover
  ];

  pythonImportsCheck = [
    "plover_stitching"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "S-t-i-t-c-h-i-n-g support for Plover";
    homepage = "https://github.com/panathea/plover_stitching";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      pandapip1
      ShamrockLee
    ];
  };
})
