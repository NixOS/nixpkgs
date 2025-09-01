{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  cython,
  pkg-config,
  libgbinder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gbinder-python";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erfanoabdi";
    repo = "gbinder-python";
    tag = version;
    hash = "sha256-up1EDuR05a7TlCErd2BXkp01oqi6hEskt7xVxsJqquM=";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [ libgbinder ];

  nativeBuildInputs = [
    pkg-config
  ];

  postPatch = ''
    # Fix pkg-config name for cross-compilation
    substituteInPlace setup.py \
      --replace-fail "pkg-config" "$PKG_CONFIG" \
      --replace-fail "USE_CYTHON = False" "USE_CYTHON = True"
  '';

  meta = {
    description = "Python bindings for libgbinder";
    homepage = "https://github.com/erfanoabdi/gbinder-python";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
