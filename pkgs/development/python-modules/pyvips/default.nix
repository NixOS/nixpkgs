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
  pythonOlder,
  setuptools,
  vips,
}:

buildPythonPackage rec {
  pname = "pyvips";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "libvips";
    repo = "pyvips";
    tag = "v${version}";
    hash = "sha256-dyous0EahUR7pkr2siBBJwzcoC4TOsnsbRo+rVE8/QQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
    vips
  ];

  build-system = [
    pkgconfig
    setuptools
  ];

  dependencies = [ cffi ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-function-pointer-types";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace pyvips/__init__.py \
      --replace 'libvips.so.42' '${lib.getLib vips}/lib/libvips${stdenv.hostPlatform.extensions.sharedLibrary}' \
      --replace 'libvips.42.dylib' '${lib.getLib vips}/lib/libvips${stdenv.hostPlatform.extensions.sharedLibrary}' \
      --replace 'libgobject-2.0.so.0' '${glib.out}/lib/libgobject-2.0${stdenv.hostPlatform.extensions.sharedLibrary}' \
      --replace 'libgobject-2.0.dylib' '${glib.out}/lib/libgobject-2.0${stdenv.hostPlatform.extensions.sharedLibrary}' \
  '';

  pythonImportsCheck = [ "pyvips" ];

  meta = with lib; {
    description = "Python wrapper for libvips";
    homepage = "https://github.com/libvips/pyvips";
    changelog = "https://github.com/libvips/pyvips/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [
      ccellado
      anthonyroussel
    ];
  };
}
