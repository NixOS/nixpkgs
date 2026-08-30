{
  lib,
  liboqs,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  # Python dependencies
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "liboqs-python";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-quantum-safe";
    repo = "liboqs-python";
    rev = finalAttrs.version;
    hash = "sha256-P3zlHQK0s3urvWy/tPJ2wZLDzvn79gFjBLg2PcnoNeU=";
  };

  postPatch = ''
    substituteInPlace oqs/oqs.py --replace-fail \
        'oqs_install_dir = home_dir / "_oqs"' \
        'oqs_install_dir = Path("${liboqs}")'
  '';

  build-system = [
    hatchling
  ];

  runtimeDependencies = [
    liboqs
  ];

  pythonImportsCheck = [
    "oqs"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python 3 bindings for liboqs";
    homepage = "https://github.com/open-quantum-safe/liboqs-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wishfort36 ];
    platforms = lib.platforms.unix;
  };
})
