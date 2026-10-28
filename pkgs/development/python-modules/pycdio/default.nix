{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  setuptools,
  pkg-config,
  swig,
  libcdio,
  libiconv,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pycdio";
  version = "2.1.1-unstable-2024-02-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "pycdio";
    rev = "806c6a2eeeeb546055ce2ac9a0ae6a14ea53ae35"; # no tag for this version (yet)
    hash = "sha256-bOm82mBUIaw4BGHj3Y24Fv5+RfAew+Ma1u4QENXoRiU=";
  };

  preConfigure = ''
    patchShebangs .
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [
    pkg-config
    swig
  ];

  buildInputs = [
    libcdio
    libiconv
  ];

  postPatch = ''
    substituteInPlace {data,test}/isofs-m1.cue \
      --replace-fail "ISOFS-M1.BIN" "isofs-m1.bin"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test/test-*.py" ];

  disabledTests = [
    # Test are depending on image files that are not there
    "test_bincue"
    "test_cdda"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://www.gnu.org/software/libcdio/";
    changelog = "https://github.com/rocky/pycdio/blob/${finalAttrs.src.rev}/ChangeLog";
    description = "Wrapper around libcdio (CD Input and Control library)";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
