{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  astropy,
  pint,
  python-dateutil,
  pytestCheckHook,
  versionCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "pvl";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "planetarypy";
    repo = "pvl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YQwuvwObPSyTimKR0VnksFXjBFzI0pof+Ug/X1VQrRc=";
  };

  build-system = [ setuptools ];

  # The `multidict` extra is left out: the experimental PVLMultiDict built on
  # it is broken with multidict >= 6.4.4.
  # https://github.com/planetarypy/pvl/issues/111
  optional-dependencies = {
    dateutil = [ python-dateutil ];
    quantities = [
      astropy
      pint
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  # pvl.new requires the multidict extra, see above.
  disabledTestPaths = [ "tests/test_new.py" ];

  disabledTests = [
    # fetch a label over the network
    "test_loadu"
    "test_loadu_args"
  ];

  pythonImportsCheck = [ "pvl" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python implementation of the Parameter Value Language (PVL) used in PDS3 and ISIS labels";
    homepage = "https://github.com/planetarypy/pvl";
    changelog = "https://github.com/planetarypy/pvl/blob/${finalAttrs.src.tag}/HISTORY.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ arunoruto ];
    mainProgram = "pvl_validate";
  };
})
