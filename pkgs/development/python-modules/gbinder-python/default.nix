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
<<<<<<< HEAD
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "waydroid";
    repo = "gbinder-python";
    tag = version;
    hash = "sha256-z0hMAvwB+uttPcP+in+C3o1ujhFSiDXKktOajnsXhPI=";
=======
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erfanoabdi";
    repo = "gbinder-python";
    tag = version;
    hash = "sha256-up1EDuR05a7TlCErd2BXkp01oqi6hEskt7xVxsJqquM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
      --replace-fail "pkg-config" "$PKG_CONFIG"
=======
      --replace-fail "pkg-config" "$PKG_CONFIG" \
      --replace-fail "USE_CYTHON = False" "USE_CYTHON = True"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  meta = {
    description = "Python bindings for libgbinder";
<<<<<<< HEAD
    homepage = "https://github.com/waydroid/gbinder-python";
    license = lib.licenses.gpl3Plus;
=======
    homepage = "https://github.com/erfanoabdi/gbinder-python";
    license = lib.licenses.gpl3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
