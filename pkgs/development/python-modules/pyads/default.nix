{
  lib,
  stdenv,
  adslib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyads";
  version = "3.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stlehmann";
    repo = "pyads";
    tag = version;
    hash = "sha256-mXWLVWzgdWIDpzfBLITLz5olhitkcp/QDrlFj2YMYLw=";
  };

  build-system = [ setuptools ];

  buildInputs = [ adslib ];

  postPatch = ''
    # Skip compilation of bundled adslib - we provide it as a separate nix package
    substituteInPlace setup.py \
      --replace-fail \
        'return sys.platform.startswith("linux") or sys.platform.startswith("darwin")' \
        'return False'

    # Load adslib from nix store instead of searching sys.path
    substituteInPlace src/pyads/pyads_ex.py \
      --replace-fail \
        'ctypes.CDLL(adslib_path)' \
        'ctypes.CDLL("${lib.getLib adslib}/lib/adslib.so")'
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  # Test suite has port reuse races and UDP timing issues on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  disabledTests = [
    # Race over UDP 48899 (no SO_REUSEADDR), occasionally segfaulting on shutdown
    "test_correct_route"
    "test_get_ams"
  ];

  pythonImportsCheck = [ "pyads" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Python wrapper for TwinCAT ADS library";
    homepage = "https://github.com/MrLeeh/pyads";
    changelog = "https://github.com/stlehmann/pyads/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
