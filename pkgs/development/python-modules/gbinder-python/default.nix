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
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "waydroid";
    repo = "gbinder-python";
    tag = version;
    hash = "sha256-z0hMAvwB+uttPcP+in+C3o1ujhFSiDXKktOajnsXhPI=";
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
      --replace-fail "pkg-config" "$PKG_CONFIG"
  '';

  meta = {
    description = "Python bindings for libgbinder";
    homepage = "https://github.com/waydroid/gbinder-python";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
