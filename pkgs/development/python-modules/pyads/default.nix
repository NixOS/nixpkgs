{
  lib,
  stdenv,
  adslib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyads";
  version = "3.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stlehmann";
    repo = "pyads";
    tag = version;
    hash = "sha256-Uh8QS9l0O1UCOM03eZ3Wo8aohgUxSbErRX2/zEUP10k=";
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

  pythonImportsCheck = [ "pyads" ];

  meta = {
    description = "Python wrapper for TwinCAT ADS library";
    homepage = "https://github.com/MrLeeh/pyads";
    changelog = "https://github.com/stlehmann/pyads/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
