{
  lib,
  stdenv,
  buildPythonPackage,
  cffi,
  fetchFromGitHub,
  glib,
  pkg-config, # from pkgs
  pkgconfig, # from pythonPackages
  pytestCheckHook,
  setuptools,
  vips,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyvips";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "libvips";
    repo = "pyvips";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N98UR6WC9ICQyBuAVejR8yrzZEBaE92EO7jY65SnaKg=";
  };

  postPatch = ''
    substituteInPlace pyvips/__init__.py \
      --replace 'libvips.so.42' '${lib.getLib vips}/lib/libvips${stdenv.hostPlatform.extensions.sharedLibrary}' \
      --replace 'libvips.42.dylib' '${lib.getLib vips}/lib/libvips${stdenv.hostPlatform.extensions.sharedLibrary}' \
      --replace 'libgobject-2.0.so.0' '${glib.out}/lib/libgobject-2.0${stdenv.hostPlatform.extensions.sharedLibrary}' \
      --replace 'libgobject-2.0.dylib' '${glib.out}/lib/libgobject-2.0${stdenv.hostPlatform.extensions.sharedLibrary}'
  '';

  build-system = [
    pkgconfig
    setuptools
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    glib
    vips
  ];

  dependencies = [ cffi ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-function-pointer-types";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # flaky due to a race condition
    # https://github.com/libvips/pyvips/issues/566
    "test_progress"
  ];

  disabledTestPaths = [
    "tests/perf"
  ];

  pythonImportsCheck = [ "pyvips" ];

  meta = {
    description = "Python wrapper for libvips";
    homepage = "https://github.com/libvips/pyvips";
    changelog = "https://github.com/libvips/pyvips/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
